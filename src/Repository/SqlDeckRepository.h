#pragma once

#include "IDeckRepository.h"

#include <QSqlDatabase>
#include <QString>

namespace PolyQ
{
    class SqlDeckRepository final : public IDeckRepository
    {
    public:
        explicit SqlDeckRepository(QString databasePath = {});
        ~SqlDeckRepository() override;

        bool Initialize() override;

        std::vector<Deck> GetAllDecks() override;
        std::optional<Deck> GetDeckById(int deckId) override;
        bool CreateDeck(const Deck& deck) override;
        bool CreateDeck(const QString& name) override;
        bool DeleteDeck(int deckId) override;
        bool DeleteDecks(const std::vector<int>& deckIds) override;
        bool UpdateDeck(int deckId, const QString& title, const QString& subtitle, bool enabled) override;

        std::vector<Flashcard> GetCardsForDeck(int deckId) override;
        std::vector<Flashcard> GetDueCardsForDeck(int deckId) override;
        bool CreateCard(int deckId, const QString& front, const QString& back) override;
        bool UpdateCard(int cardId, const QString& front, const QString& back) override;
        bool UpdateCard(const Flashcard& card) override;
        bool DeleteCard(int cardId) override;
        bool DeleteCards(const std::vector<int>& cardIds) override;

    private:
        bool CreateTables();
        Deck ReadDeck(class QSqlQuery& query) const;
        Flashcard ReadCard(class QSqlQuery& query) const;
        bool SeedTestData();
        bool Commit();

    private:
        QString m_connectionName;
        QString m_databasePath;
        QSqlDatabase m_database;
    };
}