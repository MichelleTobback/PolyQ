#pragma once

#include <QAbstractListModel>
#include <vector>

#include "../Model/Flashcard.h"

namespace PolyQ
{
    class FlashcardListModel final : public QAbstractListModel
    {
        Q_OBJECT

    public:
        enum Roles
        {
            IdRole = Qt::UserRole + 1,
            DeckIdRole,
            FrontRole,
            BackRole,
            DueAtRole,
            AcceptedAnswersRole
        };

        explicit FlashcardListModel(QObject* parent = nullptr);

        Q_INVOKABLE QVariantMap get(int row) const;
        Q_INVOKABLE QVariantMap getById(int cardId) const;

        int rowCount(const QModelIndex& parent = QModelIndex()) const override;
        QVariant data(const QModelIndex& index, int role) const override;
        QHash<int, QByteArray> roleNames() const override;

        void setCards(std::vector<Flashcard> cards);
        void updateCard(const Flashcard& card);

        Flashcard cardAt(int row) const;
        int count() const;
        bool isEmpty() const;

    private:
        std::vector<Flashcard> m_cards;
    };
}