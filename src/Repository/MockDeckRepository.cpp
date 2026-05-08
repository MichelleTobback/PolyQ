#include "MockDeckRepository.h"

#include <QDateTime>

#include <algorithm>

PolyQ::MockDeckRepository::MockDeckRepository() = default;

bool PolyQ::MockDeckRepository::Initialize()
{
    CreateDeck({ "Japanese Basics", "Basic Japanese - English words." });
    CreateDeck({ "French Verbs", "Basic French - English verbs." });
    CreateDeck({ "Russian Alphabet", "Learn the Russian Cyrillic alphabet." });

    CreateCard(0, "こんにちは", "Hello");
    CreateCard(0, "ありがとう", "Thank you");
    CreateCard(0, "猫", "Cat");

    CreateCard(1, "Être", "To be");
    CreateCard(1, "Avoir", "To have");

    CreateCard(2, "А", "A");
    CreateCard(2, "Б", "B");

    return true;
}

std::vector<PolyQ::Deck> PolyQ::MockDeckRepository::GetAllDecks()
{
    std::vector<Deck> result;
    result.reserve(m_decks.size());

    for (const Deck& deck : m_decks)
        result.push_back(BuildDeckSummary(deck));

    return result;
}

std::optional<PolyQ::Deck> PolyQ::MockDeckRepository::GetDeckById(int deckId)
{
    const auto it = m_deckIndexById.find(deckId);

    if (it == m_deckIndexById.end())
        return std::nullopt;

    return BuildDeckSummary(m_decks[it->second]);
}

bool PolyQ::MockDeckRepository::CreateDeck(const Deck& deck)
{
    Deck newDeck = deck;
    newDeck.id = m_nextId++;
    newDeck.cardCount = 0;
    newDeck.dueCount = 0;

    m_deckIndexById[newDeck.id] = m_decks.size();
    m_decks.push_back(newDeck);

    return true;
}

bool PolyQ::MockDeckRepository::CreateDeck(const QString& name)
{
    Deck deck;
    deck.title = name;
    return CreateDeck(deck);
}

bool PolyQ::MockDeckRepository::DeleteDeck(int deckId)
{
    const auto deckIt = m_deckIndexById.find(deckId);

    if (deckIt == m_deckIndexById.end())
        return false;

    m_decks.erase(m_decks.begin() + static_cast<std::ptrdiff_t>(deckIt->second));

    m_cards.erase(
        std::remove_if(
            m_cards.begin(),
            m_cards.end(),
            [deckId](const Flashcard& card)
            {
                return card.deckId == deckId;
            }
        ),
        m_cards.end()
    );

    RebuildIndexes();
    return true;
}

bool PolyQ::MockDeckRepository::UpdateDeck(int deckId, const QString& title, const QString& subtitle, bool enabled)
{
    const auto it = m_deckIndexById.find(deckId);

    if (it == m_deckIndexById.end())
        return false;

    Deck& deck = m_decks[it->second];
    deck.title = title;
    deck.subtitle = subtitle;
    deck.enabled = enabled;

    return true;
}

std::vector<PolyQ::Flashcard> PolyQ::MockDeckRepository::GetCardsForDeck(int deckId)
{
    std::vector<Flashcard> result;

    for (const Flashcard& card : m_cards)
    {
        if (card.deckId == deckId)
            result.push_back(card);
    }

    return result;
}

std::vector<PolyQ::Flashcard> PolyQ::MockDeckRepository::GetDueCardsForDeck(int deckId)
{
    const QDateTime now = QDateTime::currentDateTimeUtc();

    std::vector<Flashcard> result;

    for (const Flashcard& card : m_cards)
    {
        if (card.deckId == deckId && card.dueAt <= now)
            result.push_back(card);
    }

    return result;
}

bool PolyQ::MockDeckRepository::CreateCard(int deckId, const QString& front, const QString& back)
{
    if (!HasDeck(deckId))
        return false;

    Flashcard card;
    card.id = m_nextCardId++;
    card.deckId = deckId;
    card.front = front;
    card.back = back;

    m_cardIndexById[card.id] = m_cards.size();
    m_cards.push_back(card);

    return true;
}

bool PolyQ::MockDeckRepository::UpdateCard(int cardId, const QString& front, const QString& back)
{
    const auto it = m_cardIndexById.find(cardId);

    if (it == m_cardIndexById.end())
        return false;

    Flashcard& card = m_cards[it->second];
    card.front = front;
    card.back = back;

    return true;
}

bool PolyQ::MockDeckRepository::UpdateCard(const Flashcard& card)
{
    const auto it = m_cardIndexById.find(card.id);

    if (it == m_cardIndexById.end())
        return false;

    m_cards[it->second] = card;
    return true;
}

bool PolyQ::MockDeckRepository::DeleteCard(int cardId)
{
    const auto it = m_cardIndexById.find(cardId);

    if (it == m_cardIndexById.end())
        return false;

    m_cards.erase(m_cards.begin() + static_cast<std::ptrdiff_t>(it->second));

    RebuildIndexes();
    return true;
}

bool PolyQ::MockDeckRepository::DeleteCards(const std::vector<int>& cardIds)
{
    return false;
}

bool PolyQ::MockDeckRepository::HasDeck(int deckId) const
{
    return m_deckIndexById.find(deckId) != m_deckIndexById.end();
}

void PolyQ::MockDeckRepository::CalculateDeckStatistics(int deckId, int& cardCount, int& dueCount) const
{
    const QDateTime now = QDateTime::currentDateTimeUtc();

    cardCount = 0;
    dueCount = 0;

    for (const Flashcard& card : m_cards)
    {
        if (card.deckId != deckId)
            continue;

        ++cardCount;

        if (card.dueAt <= now)
            ++dueCount;
    }
}

PolyQ::Deck PolyQ::MockDeckRepository::BuildDeckSummary(const Deck& deck) const
{
    Deck summary = deck;
    CalculateDeckStatistics(deck.id, summary.cardCount, summary.dueCount);
    return summary;
}

void PolyQ::MockDeckRepository::RebuildIndexes()
{
    m_deckIndexById.clear();
    m_cardIndexById.clear();

    for (std::size_t i = 0; i < m_decks.size(); ++i)
        m_deckIndexById[m_decks[i].id] = i;

    for (std::size_t i = 0; i < m_cards.size(); ++i)
        m_cardIndexById[m_cards[i].id] = i;
}