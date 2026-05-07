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

bool PolyQ::SqlDeckRepository::CreateDeck(const Deck& deck)
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
        return false;
    }

    return true;
}

bool PolyQ::SqlDeckRepository::CreateDeck(const QString& name)
{
    Deck deck;
    deck.title = name.trimmed();
    deck.subtitle = "";
    deck.enabled = true;

    if (deck.title.isEmpty())
        return false;

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
        SELECT id, deck_id, front, back
        FROM cards
        WHERE deck_id = :deck_id
        ORDER BY id ASC
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
        SELECT c.id, c.deck_id, c.front, c.back
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

bool PolyQ::SqlDeckRepository::CreateCard(int deckId, const QString& front, const QString& back)
{
    if (!m_database.transaction())
        return false;

    QSqlQuery cardQuery(m_database);
    cardQuery.prepare(R"(
        INSERT INTO cards (deck_id, front, back, created_at, updated_at)
        VALUES (:deck_id, :front, :back, :created_at, :updated_at)
    )");

    const QString timestamp = nowIso();

    cardQuery.bindValue(":deck_id", deckId);
    cardQuery.bindValue(":front", front.trimmed());
    cardQuery.bindValue(":back", back.trimmed());
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
        INSERT INTO review_states (card_id, due_at)
        VALUES (:card_id, :due_at)
    )");
    reviewQuery.bindValue(":card_id", cardId);
    reviewQuery.bindValue(":due_at", timestamp);

    if (!reviewQuery.exec())
    {
        qWarning() << reviewQuery.lastError().text();
        m_database.rollback();
        return false;
    }

    return m_database.commit();
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
    return UpdateCard(card.id, card.front, card.back);
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

    struct TestDeck
    {
        QString title;
        QString subtitle;
        std::vector<std::pair<QString, QString>> cards;
    };

    const std::vector<TestDeck> decks =
    {
        {
            "Japanese Basics",
            "Greetings and common phrases",
            {
                {"Hello", "こんにちは"},
                {"Thank you", "ありがとう"},
                {"Goodbye", "さようなら"},
                {"Yes", "はい"},
                {"No", "いいえ"},
            }
        },
        {
            "Russian Basics",
            "Simple conversational words",
            {
                {"Hello", "Привет"},
                {"Good morning", "Доброе утро"},
                {"Thank you", "Спасибо"},
                {"Please", "Пожалуйста"},
                {"How are you?", "Как дела?"},
            }
        },
        {
            "French Travel",
            "Useful travel vocabulary",
            {
                {"Train station", "Gare"},
                {"Airport", "Aéroport"},
                {"Hotel", "Hôtel"},
                {"Ticket", "Billet"},
                {"Where is the bathroom?", "Où sont les toilettes ?"},
            }
        },
        {
            "Korean Food",
            "Food and restaurant terms",
            {
                {"Rice", "밥"},
                {"Water", "물"},
                {"Spicy", "매운"},
                {"Restaurant", "식당"},
                {"Delicious", "맛있어요"},
            }
        }
    };

    for (const auto& deckData : decks)
    {
        Deck deck;
        deck.title = deckData.title;
        deck.subtitle = deckData.subtitle;
        deck.enabled = true;

        if (!CreateDeck(deck))
            continue;

        QSqlQuery idQuery(m_database);

        if (!idQuery.exec("SELECT last_insert_rowid()"))
            continue;

        if (!idQuery.next())
            continue;

        const int deckId = idQuery.value(0).toInt();

        for (const auto& [front, back] : deckData.cards)
            CreateCard(deckId, front, back);
    }

    return true;
}
