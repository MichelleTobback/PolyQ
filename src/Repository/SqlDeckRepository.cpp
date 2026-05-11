#include "SqlDeckRepository.h"

#include <QDateTime>
#include <QDir>
#include <QSqlError>
#include <QSqlQuery>
#include <QStandardPaths>
#include <QUuid>
#include <QVariant>
#include <QDebug>

namespace
{
    QString defaultDatabasePath()
    {
        const QString appDataPath = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
        QDir().mkpath(appDataPath);
        return appDataPath + "/polyq.db";
    }

    QString nowIso()
    {
        return QDateTime::currentDateTimeUtc().toString(Qt::ISODate);
    }
}

PolyQ::SqlDeckRepository::SqlDeckRepository(QString databasePath)
    : m_connectionName("PolyQ_" + QUuid::createUuid().toString(QUuid::WithoutBraces))
    , m_databasePath(databasePath.isEmpty() ? defaultDatabasePath() : std::move(databasePath))
{
}

PolyQ::SqlDeckRepository::~SqlDeckRepository()
{
    if (m_database.isOpen())
        m_database.close();

    m_database = {};
    QSqlDatabase::removeDatabase(m_connectionName);
}

bool PolyQ::SqlDeckRepository::Initialize()
{
    m_database = QSqlDatabase::addDatabase("QSQLITE", m_connectionName);
    m_database.setDatabaseName(m_databasePath);

    if (!m_database.open())
    {
        qWarning() << "Failed to open PolyQ database:" << m_database.lastError().text();
        return false;
    }

    QSqlQuery foreignKeyQuery(m_database);
    foreignKeyQuery.exec("PRAGMA foreign_keys = ON");

    if (!CreateTables())
        return false;

    return SeedTestData();
}

bool PolyQ::SqlDeckRepository::CreateTables()
{
    QSqlQuery query(m_database);

    if (!query.exec(R"(
        CREATE TABLE IF NOT EXISTS decks (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            subtitle TEXT NOT NULL DEFAULT '',
            enabled INTEGER NOT NULL DEFAULT 1,
            created_at TEXT NOT NULL,
            updated_at TEXT NOT NULL
        )
    )"))
    {
        qWarning() << query.lastError().text();
        return false;
    }

    if (!query.exec(R"(
        CREATE TABLE IF NOT EXISTS cards (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            deck_id INTEGER NOT NULL,
            front TEXT NOT NULL,
            back TEXT NOT NULL,
            created_at TEXT NOT NULL,
            updated_at TEXT NOT NULL,
            FOREIGN KEY(deck_id) REFERENCES decks(id) ON DELETE CASCADE
        )
    )"))
    {
        qWarning() << query.lastError().text();
        return false;
    }

    if (!query.exec(R"(
        CREATE TABLE IF NOT EXISTS review_states (
            card_id INTEGER PRIMARY KEY,
            due_at TEXT NOT NULL,
            interval_days INTEGER NOT NULL DEFAULT 0,
            ease_factor REAL NOT NULL DEFAULT 2.5,
            repetitions INTEGER NOT NULL DEFAULT 0,
            last_reviewed_at TEXT,
            FOREIGN KEY(card_id) REFERENCES cards(id) ON DELETE CASCADE
        )
    )"))
    {
        qWarning() << query.lastError().text();
        return false;
    }

    if (!query.exec(R"(
        CREATE TABLE IF NOT EXISTS card_accepted_answers (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            card_id INTEGER NOT NULL,
            answer TEXT NOT NULL,
            FOREIGN KEY(card_id) REFERENCES cards(id) ON DELETE CASCADE
        )
    )"))
    {
        qWarning() << query.lastError().text();
        return false;
    }

    query.exec("CREATE INDEX IF NOT EXISTS idx_cards_deck_id ON cards(deck_id)");
    query.exec("CREATE INDEX IF NOT EXISTS idx_review_states_due_at ON review_states(due_at)");
    query.exec("CREATE INDEX IF NOT EXISTS idx_card_accepted_answers_card_id ON card_accepted_answers(card_id)");
    query.exec(R"(
        CREATE UNIQUE INDEX IF NOT EXISTS idx_card_accepted_answers_unique
        ON card_accepted_answers(card_id, answer)
    )");

    return true;
}

std::vector<PolyQ::Deck> PolyQ::SqlDeckRepository::GetAllDecks()
{
    std::vector<Deck> decks;

    QSqlQuery query(m_database);
    query.prepare(R"(
        SELECT
            d.id,
            d.title,
            d.subtitle,
            d.enabled,
            COUNT(c.id) AS card_count,
            SUM(CASE WHEN rs.due_at <= :now THEN 1 ELSE 0 END) AS due_count
        FROM decks d
        LEFT JOIN cards c ON c.deck_id = d.id
        LEFT JOIN review_states rs ON rs.card_id = c.id
        GROUP BY d.id
        ORDER BY d.id DESC
    )");
    query.bindValue(":now", nowIso());

    if (!query.exec())
    {
        qWarning() << query.lastError().text();
        return decks;
    }

    while (query.next())
        decks.push_back(ReadDeck(query));

    return decks;
}

std::optional<PolyQ::Deck> PolyQ::SqlDeckRepository::GetDeckById(int deckId)
{
    QSqlQuery query(m_database);
    query.prepare(R"(
        SELECT
            d.id,
            d.title,
            d.subtitle,
            d.enabled,
            COUNT(c.id) AS card_count,
            SUM(CASE WHEN rs.due_at <= :now THEN 1 ELSE 0 END) AS due_count
        FROM decks d
        LEFT JOIN cards c ON c.deck_id = d.id
        LEFT JOIN review_states rs ON rs.card_id = c.id
        WHERE d.id = :id
        GROUP BY d.id
    )");
    query.bindValue(":id", deckId);
    query.bindValue(":now", nowIso());

    if (!query.exec())
    {
        qWarning() << query.lastError().text();
        return std::nullopt;
    }

    if (!query.next())
        return std::nullopt;

    return ReadDeck(query);
}

int PolyQ::SqlDeckRepository::CreateDeck(const Deck& deck)
{
    QSqlQuery query(m_database);

    query.prepare(R"(
        INSERT INTO decks (title, subtitle, enabled, created_at, updated_at)
        VALUES (:title, :subtitle, :enabled, :created_at, :updated_at)
    )");

    const QString timestamp = nowIso();

    query.bindValue(":title", deck.title);
    query.bindValue(":subtitle", deck.subtitle);
    query.bindValue(":enabled", deck.enabled ? 1 : 0);
    query.bindValue(":created_at", timestamp);
    query.bindValue(":updated_at", timestamp);

    if (!query.exec())
    {
        qWarning() << query.lastError().text();
        return -1;
    }

    return query.lastInsertId().toInt();
}

int PolyQ::SqlDeckRepository::CreateDeck(const QString& name)
{
    Deck deck;
    deck.title = name.trimmed();
    deck.subtitle = "";
    deck.enabled = true;

    if (deck.title.isEmpty())
        return -1;

    return CreateDeck(deck);
}

bool PolyQ::SqlDeckRepository::DeleteDeck(int deckId)
{
    QSqlQuery query(m_database);
    query.prepare("DELETE FROM decks WHERE id = :id");
    query.bindValue(":id", deckId);

    if (!query.exec())
    {
        qWarning() << query.lastError().text();
        return false;
    }

    return query.numRowsAffected() > 0;
}

bool PolyQ::SqlDeckRepository::DeleteDecks(const std::vector<int>& deckIds)
{
    if (deckIds.empty())
        return true;

    if (!m_database.transaction())
        return false;

    QSqlQuery query(m_database);
    query.prepare("DELETE FROM decks WHERE id = :id");

    for (int deckId : deckIds)
    {
        query.bindValue(":id", deckId);

        if (!query.exec())
        {
            qWarning() << query.lastError().text();
            m_database.rollback();
            return false;
        }
    }

    if (!m_database.commit())
    {
        qWarning() << m_database.lastError().text();
        return false;
    }

    return true;
}

bool PolyQ::SqlDeckRepository::UpdateDeck(int deckId, const QString& title, const QString& subtitle, bool enabled)
{
    QSqlQuery query(m_database);
    query.prepare(R"(
        UPDATE decks
        SET title = :title,
            subtitle = :subtitle,
            enabled = :enabled,
            updated_at = :updated_at
        WHERE id = :id
    )");

    query.bindValue(":id", deckId);
    query.bindValue(":title", title.trimmed());
    query.bindValue(":subtitle", subtitle.trimmed());
    query.bindValue(":enabled", enabled ? 1 : 0);
    query.bindValue(":updated_at", nowIso());

    if (!query.exec())
    {
        qWarning() << query.lastError().text();
        return false;
    }

    return query.numRowsAffected() > 0;
}

std::vector<PolyQ::Flashcard> PolyQ::SqlDeckRepository::GetCardsForDeck(int deckId)
{
    std::vector<Flashcard> cards;

    QSqlQuery query(m_database);
    query.prepare(R"(
        SELECT
            c.id,
            c.deck_id,
            c.front,
            c.back,
            rs.due_at,
            rs.interval_days,
            rs.ease_factor,
            rs.repetitions
        FROM cards c
        INNER JOIN review_states rs ON rs.card_id = c.id
        WHERE c.deck_id = :deck_id
        ORDER BY c.id ASC
    )");
    query.bindValue(":deck_id", deckId);

    if (!query.exec())
    {
        qWarning() << query.lastError().text();
        return cards;
    }

    while (query.next())
        cards.push_back(ReadCard(query));

    return cards;
}

std::vector<PolyQ::Flashcard> PolyQ::SqlDeckRepository::GetDueCardsForDeck(int deckId)
{
    std::vector<Flashcard> cards;

    QSqlQuery query(m_database);
    query.prepare(R"(
        SELECT
            c.id,
            c.deck_id,
            c.front,
            c.back,
            rs.due_at,
            rs.interval_days,
            rs.ease_factor,
            rs.repetitions
        FROM cards c
        INNER JOIN review_states rs ON rs.card_id = c.id
        WHERE c.deck_id = :deck_id
          AND rs.due_at <= :now
        ORDER BY rs.due_at ASC
    )");

    query.bindValue(":deck_id", deckId);
    query.bindValue(":now", nowIso());

    if (!query.exec())
    {
        qWarning() << query.lastError().text();
        return cards;
    }

    while (query.next())
        cards.push_back(ReadCard(query));

    return cards;
}

bool PolyQ::SqlDeckRepository::CreateCard(const Flashcard& card)
{
    if (!m_database.transaction())
        return false;

    QSqlQuery cardQuery(m_database);
    cardQuery.prepare(R"(
        INSERT INTO cards (deck_id, front, back, created_at, updated_at)
        VALUES (:deck_id, :front, :back, :created_at, :updated_at)
    )");

    const QString timestamp = nowIso();

    cardQuery.bindValue(":deck_id", card.deckId);
    cardQuery.bindValue(":front", card.front.trimmed());
    cardQuery.bindValue(":back", card.back.trimmed());
    cardQuery.bindValue(":created_at", timestamp);
    cardQuery.bindValue(":updated_at", timestamp);

    if (!cardQuery.exec())
    {
        qWarning() << cardQuery.lastError().text();
        m_database.rollback();
        return false;
    }

    const int cardId = cardQuery.lastInsertId().toInt();

    QSqlQuery reviewQuery(m_database);
    reviewQuery.prepare(R"(
        INSERT INTO review_states (
            card_id,
            due_at,
            interval_days,
            ease_factor,
            repetitions
        )
        VALUES (
            :card_id,
            :due_at,
            :interval_days,
            :ease_factor,
            :repetitions
        )
    )");

    reviewQuery.bindValue(":card_id", cardId);
    reviewQuery.bindValue(":due_at", card.dueAt.toUTC().toString(Qt::ISODate));
    reviewQuery.bindValue(":interval_days", card.intervalDays);
    reviewQuery.bindValue(":ease_factor", card.easeFactor);
    reviewQuery.bindValue(":repetitions", card.reviewCount);

    if (!reviewQuery.exec())
    {
        qWarning() << reviewQuery.lastError().text();
        m_database.rollback();
        return false;
    }

    if (!SaveAcceptedAnswers(cardId, card.acceptedAnswers))
    {
        m_database.rollback();
        return false;
    }

    return Commit();
}

bool PolyQ::SqlDeckRepository::CreateCard(int deckId, const QString& front, const QString& back)
{
    Flashcard card;
    card.deckId = deckId;
    card.front = front.trimmed();
    card.back = back.trimmed();
    card.dueAt = QDateTime::currentDateTimeUtc();

    return CreateCard(card);
}

bool PolyQ::SqlDeckRepository::UpdateCard(int cardId, const QString& front, const QString& back)
{
    QSqlQuery query(m_database);
    query.prepare(R"(
        UPDATE cards
        SET front = :front,
            back = :back,
            updated_at = :updated_at
        WHERE id = :id
    )");

    query.bindValue(":id", cardId);
    query.bindValue(":front", front.trimmed());
    query.bindValue(":back", back.trimmed());
    query.bindValue(":updated_at", nowIso());

    if (!query.exec())
    {
        qWarning() << query.lastError().text();
        return false;
    }

    return query.numRowsAffected() > 0;
}

bool PolyQ::SqlDeckRepository::UpdateCard(const Flashcard& card)
{
    if (!m_database.transaction())
        return false;

    QSqlQuery cardQuery(m_database);
    cardQuery.prepare(R"(
        UPDATE cards
        SET front = :front,
            back = :back,
            updated_at = :updated_at
        WHERE id = :id
    )");

    cardQuery.bindValue(":id", card.id);
    cardQuery.bindValue(":front", card.front.trimmed());
    cardQuery.bindValue(":back", card.back.trimmed());
    cardQuery.bindValue(":updated_at", nowIso());

    if (!cardQuery.exec())
    {
        qWarning() << cardQuery.lastError().text();
        m_database.rollback();
        return false;
    }

    QSqlQuery reviewQuery(m_database);
    reviewQuery.prepare(R"(
        UPDATE review_states
        SET due_at = :due_at,
            interval_days = :interval_days,
            ease_factor = :ease_factor,
            repetitions = :repetitions,
            last_reviewed_at = :last_reviewed_at
        WHERE card_id = :card_id
    )");

    reviewQuery.bindValue(":card_id", card.id);
    reviewQuery.bindValue(":due_at", card.dueAt.toUTC().toString(Qt::ISODate));
    reviewQuery.bindValue(":interval_days", card.intervalDays);
    reviewQuery.bindValue(":ease_factor", card.easeFactor);
    reviewQuery.bindValue(":repetitions", card.reviewCount);
    reviewQuery.bindValue(":last_reviewed_at", nowIso());

    if (!reviewQuery.exec())
    {
        qWarning() << reviewQuery.lastError().text();
        m_database.rollback();
        return false;
    }

    if (!SaveAcceptedAnswers(card.id, card.acceptedAnswers))
    {
        m_database.rollback();
        return false;
    }

    return Commit();
}

bool PolyQ::SqlDeckRepository::DeleteCard(int cardId)
{
    QSqlQuery query(m_database);
    query.prepare("DELETE FROM cards WHERE id = :id");
    query.bindValue(":id", cardId);

    if (!query.exec())
    {
        qWarning() << query.lastError().text();
        return false;
    }

    return query.numRowsAffected() > 0;
}

bool PolyQ::SqlDeckRepository::DeleteCards(const std::vector<int>& cardIds)
{
    if (cardIds.empty())
        return true;

    if (!m_database.transaction())
        return false;

    QSqlQuery query(m_database);
    query.prepare("DELETE FROM cards WHERE id = :id");

    for (int cardId : cardIds)
    {
        query.bindValue(":id", cardId);

        if (!query.exec())
        {
            qWarning() << query.lastError().text();
            m_database.rollback();
            return false;
        }
    }

    if (!m_database.commit())
    {
        qWarning() << m_database.lastError().text();
        return false;
    }

    return true;
}

PolyQ::Deck PolyQ::SqlDeckRepository::ReadDeck(QSqlQuery& query) const
{
    Deck deck;
    deck.id = query.value("id").toInt();
    deck.title = query.value("title").toString();
    deck.subtitle = query.value("subtitle").toString();
    deck.enabled = query.value("enabled").toInt() != 0;
    deck.cardCount = query.value("card_count").toInt();
    deck.dueCount = query.value("due_count").toInt();
    return deck;
}

PolyQ::Flashcard PolyQ::SqlDeckRepository::ReadCard(QSqlQuery& query) const
{
    Flashcard card;
    card.id = query.value("id").toInt();
    card.deckId = query.value("deck_id").toInt();
    card.front = query.value("front").toString();
    card.back = query.value("back").toString();
    card.acceptedAnswers = LoadAcceptedAnswers(card.id);

    card.dueAt = QDateTime::fromString(query.value("due_at").toString(), Qt::ISODate);
    card.intervalDays = query.value("interval_days").toInt();
    card.easeFactor = query.value("ease_factor").toDouble();
    card.reviewCount = query.value("repetitions").toInt();

    return card;
}

bool PolyQ::SqlDeckRepository::SeedTestData()
{
    QSqlQuery countQuery(m_database);

    if (!countQuery.exec("SELECT COUNT(*) FROM decks"))
    {
        qWarning() << countQuery.lastError().text();
        return false;
    }

    if (!countQuery.next())
        return false;

    const int deckCount = countQuery.value(0).toInt();

    if (deckCount > 0)
        return true;

    struct TestCard
    {
        QString front;
        QString back;
        QStringList acceptedAnswers;
    };

    struct TestDeck
    {
        QString title;
        QString subtitle;
        std::vector<TestCard> cards;
    };

    const std::vector<TestDeck> decks =
    {
        {
            "Japanese Basics",
            "Greetings and common phrases",
            {
                { "Hello", "こんにちは", { "Konnichiwa", "Kon'nichiwa" } },
                { "Thank you", "ありがとう", { "Arigatou", "Arigato" } },
                { "Goodbye", "さようなら", { "Sayounara", "Sayonara" } },
                { "Yes", "はい", { "Hai" } },
                { "No", "いいえ", { "Iie" } },
            }
        },
        {
            "Russian Basics",
            "Simple conversational words",
            {
                { "Hello", "Привет", { "Privet" } },
                { "Good morning", "Доброе утро", { "Dobroye utro" } },
                { "Thank you", "Спасибо", { "Spasibo" } },
                { "Please", "Пожалуйста", { "Pozhaluysta" } },
                { "How are you?", "Как дела?", { "Kak dela?" } },
            }
        },
        {
            "French Travel",
            "Useful travel vocabulary",
            {
                { "Train station", "Gare", {} },
                { "Airport", "Aéroport", { "Aeroport" } },
                { "Hotel", "Hôtel", { "Hotel" } },
                { "Ticket", "Billet", {} },
                { "Where is the bathroom?", "Où sont les toilettes ?", { "Ou sont les toilettes ?" } },
            }
        },
        {
            "Korean Food",
            "Food and restaurant terms",
            {
                { "Rice", "밥", { "Bap" } },
                { "Water", "물", { "Mul" } },
                { "Spicy", "매운", { "Maeun" } },
                { "Restaurant", "식당", { "Sikdang" } },
                { "Delicious", "맛있어요", { "Masisseoyo", "Mashisseoyo" } },
            }
        }
    };

    for (const auto& deckData : decks)
    {
        Deck deck;
        deck.title = deckData.title;
        deck.subtitle = deckData.subtitle;
        deck.enabled = true;

        const int deckId = CreateDeck(deck);

        if (deckId < 0)
            continue;

        for (const TestCard& cardData : deckData.cards)
        {
            Flashcard card;
            card.deckId = deckId;
            card.front = cardData.front;
            card.back = cardData.back;
            card.acceptedAnswers = cardData.acceptedAnswers;
            card.dueAt = QDateTime::currentDateTimeUtc();

            CreateCard(card);
        }
    }

    return true;
}

bool PolyQ::SqlDeckRepository::Commit()
{
    if (!m_database.commit())
    {
        qWarning() << m_database.lastError().text();
        return false;
    }

    return true;
}

bool PolyQ::SqlDeckRepository::SaveAcceptedAnswers(int cardId, const QStringList& answers)
{
    QSqlQuery deleteQuery(m_database);
    deleteQuery.prepare("DELETE FROM card_accepted_answers WHERE card_id = :card_id");
    deleteQuery.bindValue(":card_id", cardId);

    if (!deleteQuery.exec())
    {
        qWarning() << deleteQuery.lastError().text();
        return false;
    }

    QSqlQuery insertQuery(m_database);
    insertQuery.prepare(R"(
        INSERT INTO card_accepted_answers (card_id, answer)
        VALUES (:card_id, :answer)
    )");

    for (const QString& answer : answers)
    {
        const QString trimmed = answer.trimmed();

        if (trimmed.isEmpty())
            continue;

        insertQuery.bindValue(":card_id", cardId);
        insertQuery.bindValue(":answer", trimmed);

        if (!insertQuery.exec())
        {
            qWarning() << insertQuery.lastError().text();
            return false;
        }
    }

    return true;
}

QStringList PolyQ::SqlDeckRepository::LoadAcceptedAnswers(int cardId) const
{
    QStringList answers;

    QSqlQuery query(m_database);
    query.prepare(R"(
        SELECT answer
        FROM card_accepted_answers
        WHERE card_id = :card_id
        ORDER BY id ASC
    )");

    query.bindValue(":card_id", cardId);

    if (!query.exec())
    {
        qWarning() << query.lastError().text();
        return answers;
    }

    while (query.next())
        answers.push_back(query.value("answer").toString());

    return answers;
}
