#include "MockDeckRepository.h"

#include <vector>

PolyQ::MockDeckRepository::MockDeckRepository()
{
    
}

bool PolyQ::MockDeckRepository::Initialize()
{
    CreateDeck("Japanese Basics");
    CreateDeck("French Verbs");
    CreateDeck("Russian Alphabet");

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
    return m_decks;
}

bool PolyQ::MockDeckRepository::CreateDeck(const QString& name)
{
    Deck deck;
    deck.id = m_nextId++;
    deck.title = name;
    deck.cardCount = 0;

    m_decks.push_back(deck);
    return true;
}

bool PolyQ::MockDeckRepository::DeleteDeck(int deckId)
{
    m_cards.erase(std::remove_if(m_cards.begin(), m_cards.end(), [deckId](const Flashcard& card)
        {
            return card.deckId == deckId;
        }), m_cards.end());

    m_decks.erase(std::remove_if(m_decks.begin(), m_decks.end(), [deckId](const Deck& deck)
        {
            return deck.id == deckId;
        }), m_decks.end());

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

bool PolyQ::MockDeckRepository::CreateCard(int deckId, const QString& front, const QString& back)
{
    if (deckId >= m_decks.size())
        return false;

    m_cards.push_back({
            m_nextCardId++,
            deckId,
            front,
            back
        });

    ++m_decks[deckId].cardCount;

    return true;
}

bool PolyQ::MockDeckRepository::UpdateCard(int cardId, const QString& front, const QString& back)
{
    for (Flashcard& card : m_cards)
    {
        if (card.id == cardId)
        {
            card.front = front;
            card.back = back;
            return true;
        }
    }

    return false;
}

bool PolyQ::MockDeckRepository::DeleteCard(int cardId)
{
    m_cards.erase(std::remove_if(m_cards.begin(), m_cards.end(), [cardId](const Flashcard& card)
        {
            return card.id == cardId;
        }), m_cards.end());

    return true;
}

void PolyQ::MockDeckRepository::UpdateCardCounts()
{
    for (Deck& deck : m_decks)
    {
        deck.cardCount = 0;

        for (const Flashcard& card : m_cards)
        {
            if (card.deckId == deck.id)
                deck.cardCount++;
        }
    }
}
