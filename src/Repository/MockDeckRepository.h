#pragma once

#include "IDeckRepository.h"

namespace PolyQ
{
    class MockDeckRepository final : public IDeckRepository
    {
    public:
        MockDeckRepository();

        virtual bool Initialize() override;

        virtual std::vector<Deck> GetAllDecks() override;
        virtual bool CreateDeck(const Deck& deck) override;
        virtual bool CreateDeck(const QString& name) override;
        virtual bool DeleteDeck(int deckId) override;

        virtual std::vector<Flashcard> GetCardsForDeck(int deckId) override;
        virtual bool CreateCard(int deckId, const QString& front, const QString& back) override;
        virtual bool UpdateCard(int cardId, const QString& front, const QString& back) override;
        virtual bool DeleteCard(int cardId) override;


    private:
        std::vector<Deck> m_decks;
        std::vector<Flashcard> m_cards;

        int m_nextId = 0;
        int m_nextCardId = 0;

        void UpdateCardCounts();
    };
}