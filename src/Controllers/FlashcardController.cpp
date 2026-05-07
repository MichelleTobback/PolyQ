#include "FlashcardController.h"

#include "../Repository/SqlDeckRepository.h"

PolyQ::FlashcardController::FlashcardController(QObject* parent)
    : QObject(parent)
{
    m_pRepository = std::make_unique<SqlDeckRepository>();
    m_pRepository->Initialize();

    connect(&m_dueRefreshTimer, &QTimer::timeout, this, [this]()
        {
            refreshSelectedDeck();
        });

    m_dueRefreshTimer.start(60 * 1000);

    loadDecks();
}

PolyQ::FlashcardController::~FlashcardController() = default;

QVariantMap PolyQ::FlashcardController::currentCard() const
{
    const auto card = m_reviewSession.CurrentCard();

    if (!card.has_value())
        return {};

    return {
        { "id", card->id },
        { "deckId", card->deckId },
        { "front", card->front },
        { "back", card->back }
    };
}

QVariantMap PolyQ::FlashcardController::currentDeck() const
{
    if (m_selectedDeckId < 0)
        return {};

    const std::optional<Deck> deck = m_DeckModel.deckById(m_selectedDeckId);

    if (!deck.has_value())
        return {};

    return {
        { "id", deck->id },
        { "title", deck->title },
        { "subtitle", deck->subtitle },
        { "cardCount", deck->cardCount },
        { "dueCount", deck->dueCount },
        { "enabled", deck->enabled }
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

void PolyQ::FlashcardController::startDueReview()
{
    m_reviewSettings.mode = ReviewSessionMode::SpacedRepetition;
    startReviewSession(m_selectedDeckId);
    emit reviewModeChanged();
}

void PolyQ::FlashcardController::startEndlessReview()
{
    m_reviewSettings.mode = ReviewSessionMode::AllCards;
    startReviewSession(m_selectedDeckId);
    emit reviewModeChanged();
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

    loadCards(deckId);
    startReviewSession(deckId);

    emit selectedDeckChanged();
    emit cardChanged();
    emit showingAnswerChanged();
}

void PolyQ::FlashcardController::createDeck(const QString& name)
{
    const QString trimmedName = name.trimmed();

    if (trimmedName.isEmpty())
        return;

    if (m_pRepository->CreateDeck(trimmedName))
        loadDecks();
}

void PolyQ::FlashcardController::updateDeck(const QString& title, const QString& subtitle, bool enabled)
{
    if (m_selectedDeckId < 0)
        return;

    if (!m_pRepository->UpdateDeck(m_selectedDeckId, title, subtitle, enabled))
        return;

    loadDecks();

    emit selectedDeckChanged();
}

void PolyQ::FlashcardController::createCard(const QString& front, const QString& back)
{
    if (m_selectedDeckId < 0)
        return;

    const QString trimmedFront = front.trimmed();
    const QString trimmedBack = back.trimmed();

    if (trimmedFront.isEmpty() || trimmedBack.isEmpty())
        return;

    if (!m_pRepository->CreateCard(m_selectedDeckId, trimmedFront, trimmedBack))
        return;

    loadCards(m_selectedDeckId);
    startReviewSession(m_selectedDeckId);
    loadDecks();

    emit selectedDeckChanged();
    emit cardChanged();
    emit showingAnswerChanged();
}

void PolyQ::FlashcardController::updateCard(int cardId, const QString& front, const QString& back)
{
    if (m_selectedDeckId < 0)
        return;

    const QString trimmedFront = front.trimmed();
    const QString trimmedBack = back.trimmed();

    if (trimmedFront.isEmpty() || trimmedBack.isEmpty())
        return;

    if (!m_pRepository->UpdateCard(cardId, trimmedFront, trimmedBack))
        return;

    loadCards(m_selectedDeckId);
    startReviewSession(m_selectedDeckId);
    loadDecks();

    emit selectedDeckChanged();
    emit cardChanged();
    emit showingAnswerChanged();
}

void PolyQ::FlashcardController::reviewCard(int rating)
{
    const ReviewRating reviewRating = static_cast<ReviewRating>(rating);

    const auto updatedCard = m_reviewSession.SubmitRating(reviewRating);
    if (updatedCard.has_value())
    {
        m_pRepository->UpdateCard(updatedCard.value());

        if (reviewRating != ReviewRating::Again)
        {
            m_DeckModel.adjustDueCount(m_selectedDeckId, -1);
            emit reviewProgressChanged();
        }
    }

    updateCurrentCardFromSession();
}

void PolyQ::FlashcardController::loadCards(int deckId)
{
    m_cardModel.setCards(m_pRepository->GetCardsForDeck(deckId));
}

void PolyQ::FlashcardController::startReviewSession(int deckId)
{
    std::vector<Flashcard> dueCards;
    switch (m_reviewSettings.mode)
    {
    case ReviewSessionMode::AllCards:
        dueCards = m_pRepository->GetCardsForDeck(deckId);
        break;
    case ReviewSessionMode::SpacedRepetition:
        dueCards = m_pRepository->GetDueCardsForDeck(deckId);
        break;
    }

    m_reviewSession.Start(dueCards, m_reviewSettings);

    m_cardIndex = m_reviewSession.HasCards() ? 0 : -1;
    m_showingAnswer = false;
}

void PolyQ::FlashcardController::updateCurrentCardFromSession()
{
    m_showingAnswer = false;

    if (!m_reviewSession.HasCards())
    {
        m_cardIndex = -1;
    }
    else
    {
        ++m_cardIndex;
    }

    emit cardChanged();
    emit showingAnswerChanged();
    emit selectedDeckChanged();
}

void PolyQ::FlashcardController::refreshSelectedDeck()
{
    if (m_selectedDeckId < 0)
        return;

    const auto deck = m_pRepository->GetDeckById(m_selectedDeckId);
    if (!deck.has_value())
        return;

    m_DeckModel.updateDeck(deck.value());

    emit selectedDeckChanged();
}
