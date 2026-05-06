#pragma once
#include "../Model/Deck.h"
#include "../Model/Flashcard.h"

#include <QString>
#include <vector>

namespace PolyQ
{
	class IDeckRepository
	{
	public:
		virtual ~IDeckRepository() = default;

		virtual bool Initialize() = 0;

		virtual std::vector<Deck> GetAllDecks() = 0;
		virtual bool CreateDeck(const Deck& deck) = 0;
		virtual bool CreateDeck(const QString& name) = 0;
		virtual bool DeleteDeck(int deckId) = 0;
		virtual bool UpdateDeck(int deckId, const QString& title, const QString& subtitle, bool enabled) = 0;

		virtual std::vector<Flashcard> GetCardsForDeck(int deckId) = 0;
		virtual bool CreateCard(int deckId, const QString& front, const QString& back) = 0;
		virtual bool UpdateCard(int cardId, const QString& front, const QString& back) = 0;
		virtual bool DeleteCard(int cardId) = 0;
	};
}