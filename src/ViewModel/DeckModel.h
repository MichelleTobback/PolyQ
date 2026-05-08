#pragma once

#include <QAbstractListModel>
#include <QString>

#include <vector>
#include <optional>

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
            CardCountRole,
            DueCountRole,
            EnabledRole
        };

        explicit DeckModel(QObject* parent = nullptr)
            : QAbstractListModel(parent)
        {
        }

        Q_INVOKABLE QVariantMap get(int index) const
        {
            QVariantMap deck;

            if (index < 0 || index >= static_cast<int>(m_Decks.size()))
                return deck;

            const Deck& item = m_Decks[index];

            deck["deckId"] = item.id;
            deck["title"] = item.title;
            deck["subtitle"] = item.subtitle;
            deck["dueCount"] = item.dueCount;
            deck["enabled"] = item.enabled;

            return deck;
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

        std::optional<PolyQ::Deck> deckById(int deckId) const
        {
            for (const Deck& deck : m_Decks)
            {
                if (deck.id == deckId)
                    return deck;
            }

            return std::nullopt;
        }

        void updateDeck(const Deck& updatedDeck)
        {
            for (int row = 0; row < m_Decks.size(); ++row)
            {
                if (m_Decks[row].id != updatedDeck.id)
                    continue;

                m_Decks[row] = updatedDeck;

                const QModelIndex index = createIndex(row, 0);

                emit dataChanged(index, index, {
                    TitleRole,
                    SubtitleRole,
                    CardCountRole,
                    DueCountRole,
                    EnabledRole
                    });

                return;
            }
        }

        void adjustDueCount(int deckId, int delta)
        {
            for (int row = 0; row < static_cast<int>(m_Decks.size()); ++row)
            {
                Deck& deck = m_Decks[row];

                if (deck.id != deckId)
                    continue;

                deck.dueCount = std::max(0, deck.dueCount + delta);

                const QModelIndex modelIndex = index(row);
                emit dataChanged(modelIndex, modelIndex, { DueCountRole });

                return;
            }
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