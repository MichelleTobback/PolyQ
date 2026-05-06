#include "FlashcardController.h"

#include "../Repository/MockDeckRepository.h"

PolyQ::FlashcardController::FlashcardController(QObject* parent)
    : QObject(parent)
{
    m_pRepository = std::make_unique<MockDeckRepository>();
    m_pRepository->Initialize();

    loadDecks();
}

PolyQ::FlashcardController::~FlashcardController()
{

}

QVariantMap PolyQ::FlashcardController::currentCard() const
{
    if (m_cardModel.isEmpty())
        return {};

    const Flashcard card = m_cardModel.cardAt(m_cardIndex);

    return {
        { "id", card.id },
        { "deckId", card.deckId },
        { "front", card.front },
        { "back", card.back }
    };
}

QVariantMap PolyQ::FlashcardController::currentDeck() const
{
    if (m_DeckModel.isEmpty())
        return {};

    const Deck deck = m_DeckModel.deckAt(m_selectedDeckId);

    return {
        { "id", deck.id },
        { "title", deck.title },
        { "subtitle", deck.subtitle },
        { "cardCount", deck.cardCount },
        { "dueCount", deck.dueCount },
        { "enabled", deck.enabled }
    };
}

bool PolyQ::FlashcardController::showingAnswer() const
{
    return m_showingAnswer;
}

int PolyQ::FlashcardController::cardIndex() const
{
    return m_cardIndex;
}

void PolyQ::FlashcardController::showAnswer()
{
    if (m_showingAnswer)
        return;

    m_showingAnswer = true;
    emit showingAnswerChanged();
}

void PolyQ::FlashcardController::reviewAgain()
{
    reviewCard(0);
}

void PolyQ::FlashcardController::reviewHard()
{
    reviewCard(1);
}

void PolyQ::FlashcardController::reviewGood()
{
    reviewCard(2);
}

void PolyQ::FlashcardController::reviewEasy()
{
    reviewCard(3);
}

void PolyQ::FlashcardController::loadDecks()
{
    m_DeckModel.setDecks(m_pRepository->GetAllDecks());
}

void PolyQ::FlashcardController::selectDeck(int deckId)
{
    if (m_selectedDeckId == deckId)
        return;

    m_selectedDeckId = deckId;
    emit selectedDeckChanged();

    loadCards(deckId);
    nextCard();
}

void PolyQ::FlashcardController::createDeck(const QString& name)
{
    const QString trimmedName = name.trimmed();

    if (trimmedName.isEmpty())
        return;

    if (m_pRepository->CreateDeck(trimmedName))
        loadDecks();
}

void PolyQ::FlashcardController::createCard(const QString& front, const QString& back)
{
    if (m_selectedDeckId == -1)
        return;

    if (front.trimmed().isEmpty() || back.trimmed().isEmpty())
        return;

    if (m_pRepository->CreateCard(m_selectedDeckId, front.trimmed(), back.trimmed()))
    {
        m_cardModel.setCards(m_pRepository->GetCardsForDeck(m_selectedDeckId));
        loadDecks();
    }
}

void PolyQ::FlashcardController::reviewCard(int rating)
{
    Q_UNUSED(rating);

    nextCard();
}

void PolyQ::FlashcardController::loadCards(int deckId)
{
    m_cardModel.setCards(m_pRepository->GetCardsForDeck(deckId));
}

void PolyQ::FlashcardController::nextCard()
{
    if (m_cardModel.isEmpty())
        return;

    m_cardIndex = (m_cardIndex + 1) % m_cardModel.count();
    m_showingAnswer = false;

    emit cardChanged();
    emit showingAnswerChanged();
}