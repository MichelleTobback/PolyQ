#include "FlashcardListModel.h"

PolyQ::FlashcardListModel::FlashcardListModel(QObject* parent)
    : QAbstractListModel(parent)
{
}

QVariantMap PolyQ::FlashcardListModel::get(int row) const
{
    if (row < 0 || row >= static_cast<int>(m_cards.size()))
        return {};

    const Flashcard& card = m_cards[row];

    return {
        { "cardId", card.id },
        { "deckId", card.deckId },
        { "front", card.front },
        { "back", card.back },
        { "dueAt", card.dueAt }
    };
}

int PolyQ::FlashcardListModel::rowCount(const QModelIndex& parent) const
{
    if (parent.isValid())
        return 0;

    return static_cast<int>(m_cards.size());
}

QVariant PolyQ::FlashcardListModel::data(const QModelIndex& index, int role) const
{
    if (!index.isValid())
        return {};

    const int row = index.row();

    if (row < 0 || row >= static_cast<int>(m_cards.size()))
        return {};

    const Flashcard& card = m_cards[row];

    switch (role)
    {
    case IdRole:
        return card.id;
    case DeckIdRole:
        return card.deckId;
    case FrontRole:
        return card.front;
    case BackRole:
        return card.back;
    case DueAtRole:
        return card.dueAt;
    default:
        return {};
    }
}

QHash<int, QByteArray> PolyQ::FlashcardListModel::roleNames() const
{
    return {
        { IdRole, "cardId" },
        { DeckIdRole, "deckId" },
        { FrontRole, "front" },
        { BackRole, "back" },
        { DueAtRole, "dueAt" }
    };
}

void PolyQ::FlashcardListModel::setCards(std::vector<Flashcard> cards)
{
    beginResetModel();
    m_cards = std::move(cards);
    endResetModel();
}

void PolyQ::FlashcardListModel::updateCard(const Flashcard& card)
{
    for (int row = 0; row < static_cast<int>(m_cards.size()); ++row)
    {
        if (m_cards[row].id != card.id)
            continue;

        m_cards[row] = card;

        const QModelIndex modelIndex = index(row);

        emit dataChanged(
            modelIndex,
            modelIndex,
            {
                FrontRole,
                BackRole,
                DueAtRole
            }
        );

        return;
    }
}

PolyQ::Flashcard PolyQ::FlashcardListModel::cardAt(int row) const
{
    if (row < 0 || row >= static_cast<int>(m_cards.size()))
        return {};

    return m_cards[row];
}

int PolyQ::FlashcardListModel::count() const
{
    return static_cast<int>(m_cards.size());
}

bool PolyQ::FlashcardListModel::isEmpty() const
{
    return m_cards.size() == 0;
}
