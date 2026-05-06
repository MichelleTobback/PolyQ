#pragma once

#include <QAbstractListModel>
#include <QString>

#include <vector>

#include "../Model/Deck.h"

namespace PolyQ
{
    class DeckModel final : public QAbstractListModel
    {
        Q_OBJECT

    public:
        enum DeckRoles
        {
            IdRole = Qt::UserRole + 1,
            TitleRole,
            SubtitleRole,
            DueCountRole,
            EnabledRole
        };

        explicit DeckModel(QObject* parent = nullptr)
            : QAbstractListModel(parent)
        {
        }

        int rowCount(const QModelIndex& parent = QModelIndex()) const override
        {
            if (parent.isValid())
                return 0;

            return static_cast<int>(m_Decks.size());
        }

        QVariant data(const QModelIndex& index, int role = Qt::DisplayRole) const override
        {
            if (!index.isValid())
                return {};

            const int row = index.row();

            if (row < 0 || row >= static_cast<int>(m_Decks.size()))
                return {};

            const Deck& deck = m_Decks[row];

            switch (role)
            {
            case IdRole:
                return deck.id;
            case TitleRole:
                return deck.title;
            case SubtitleRole:
                return deck.subtitle;
            case DueCountRole:
                return deck.dueCount;
            case EnabledRole:
                return deck.enabled;
            default:
                return {};
            }
        }

        QHash<int, QByteArray> roleNames() const override
        {
            return {
                { IdRole, "deckId" },
                { TitleRole, "title" },
                { SubtitleRole, "subtitle" },
                { DueCountRole, "dueCount" },
                { EnabledRole, "enabled" }
            };
        }

        void setDecks(std::vector<Deck> decks)
        {
            beginResetModel();
            m_Decks = std::move(decks);
            endResetModel();
        }

        void addDeck(const Deck& deck)
        {
            const int row = static_cast<int>(m_Decks.size());

            beginInsertRows(QModelIndex(), row, row);
            m_Decks.push_back(deck);
            endInsertRows();
        }

        void clear()
        {
            beginResetModel();
            m_Decks.clear();
            endResetModel();
        }

        Deck deckAt(int row) const
        {
            if (row < 0 || row >= static_cast<int>(m_Decks.size()))
                return {};

            return m_Decks[row];
        }

        int count() const
        {
            return static_cast<int>(m_Decks.size());
        }

        bool isEmpty() const
        {
            return m_Decks.size() == 0;
        }

    private:
        std::vector<Deck> m_Decks;
    };
}