#pragma once

#include "IDeckRepository.h"

#include <unordered_map>

namespace PolyQ
{
    class MockDeckRepository final : public IDeckRepository
    {
    public:
        MockDeckRepository();

        bool Initialize() override;

        std::vector<Deck> GetAllDecks() override;
        std::optional<Deck> GetDeckById(int deckId) override;

        bool CreateDeck(const Deck& deck) override;
        bool CreateDeck(const QString& name) override;
        bool DeleteDeck(int deckId) override;
        bool UpdateDeck(int deckId, const QString& title, const QString& subtitle, bool enabled) override;

        std::vector<Flashcard> GetCardsForDeck(int deckId) override;
        std::vector<Flashcard> GetDueCardsForDeck(int deckId) override;

        bool CreateCard(int deckId, const QString& front, const QString& back) override;
        bool UpdateCard(int cardId, const QString& front, const QString& back) override;
        bool UpdateCard(const Flashcard& card) override;
        bool DeleteCard(int cardId) override;
        bool DeleteCards(const std::vector<int>& cardIds) override;

    private:
        bool HasDeck(int deckId) const;

        void CalculateDeckStatistics(int deckId, int& cardCount, int& dueCount) const;

        Deck BuildDeckSummary(const Deck& deck) const;

        void RebuildIndexes();

    private:
        std::vector<Deck> m_decks;
        std::vector<Flashcard> m_cards;

        std::unordered_map<int, std::size_t> m_deckIndexById;
        std::unordered_map<int, std::size_t> m_cardIndexById;

        int m_nextId = 0;
        int m_nextCardId = 0;
    };
}