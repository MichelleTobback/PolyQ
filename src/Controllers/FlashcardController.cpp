#include "FlashcardController.h"

#include "../Repository/SqlDeckRepository.h"

#include <QDateTime>
#include <QtGlobal>

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
        { "back", card->back },
        { "acceptedAnswers", card->acceptedAnswers }
    };
}

QVariantMap PolyQ::FlashcardController::currentDeck() const
{
    if (m_selectedDeckId < 0)
        return {};

    const std::optional<Deck> deck = m_deckModel.deckById(m_selectedDeckId);

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

bool PolyQ::FlashcardController::canContinueReview() const
{
    return m_reviewSession.CanContinue();
}

bool PolyQ::FlashcardController::reviewFinished() const
{
    return m_reviewSession.TotalCount() > 0 && !m_reviewSession.HasCards();
}

void PolyQ::FlashcardController::checkResults(const QString& userInput)
{
    const ReviewResult result = m_reviewSession.SubmitAnswer(userInput);

    applyReviewResult(result);

    if (result.answerResult.has_value())
        setLastAnswerState(result.answerResult->accepted ? 1 : 2);
    else
        setLastAnswerState(0);

    showAnswer();
}

void PolyQ::FlashcardController::showAnswer()
{
    if (m_showingAnswer)
        return;

    m_showingAnswer = true;
    emit showingAnswerChanged();
}

void PolyQ::FlashcardController::nextCard()
{
    updateCurrentCardFromSession();
}

void PolyQ::FlashcardController::startConfiguredReview()
{
    startReviewSession(m_selectedDeckId);

    emit reviewModeChanged();
    emit reviewProgressChanged();
}

void PolyQ::FlashcardController::configureReviewSettings(
    int sessionMode, 
    int inputMode, 
    int strictness, 
    bool caseSensitive, 
    bool ignoreAccents, 
    bool ignorePunctuation)
{
    //TODO - move to viewmodel
    m_reviewSettings.mode = static_cast<ReviewSessionMode>(sessionMode);
    m_reviewSettings.inputMode = static_cast<ReviewInputMode>(inputMode);
    m_reviewSettings.validation.strictness = static_cast<SpellingStrictness>(strictness);

    m_reviewSettings.validation.caseSensitive = caseSensitive;
    m_reviewSettings.validation.ignoreAccents = ignoreAccents;
    m_reviewSettings.validation.ignorePunctuation = ignorePunctuation;

    emit reviewModeChanged();
}

void PolyQ::FlashcardController::reviewAgain()
{
    reviewCard(ReviewRating::Again);
}

void PolyQ::FlashcardController::reviewHard()
{
    reviewCard(ReviewRating::Hard);
}

void PolyQ::FlashcardController::reviewGood()
{
    reviewCard(ReviewRating::Good);
}

void PolyQ::FlashcardController::reviewEasy()
{
    reviewCard(ReviewRating::Easy);
}

void PolyQ::FlashcardController::loadDecks()
{
    m_deckModel.setDecks(m_pRepository->GetAllDecks());
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
    emit reviewProgressChanged();
    emit canContinueReviewChanged();
}

int PolyQ::FlashcardController::createDeck(const QString& name)
{
    const QString trimmedName = name.trimmed();

    if (trimmedName.isEmpty())
        return - 1;

    const int deckId = m_pRepository->CreateDeck(name);

    loadDecks();

    return deckId;
}

void PolyQ::FlashcardController::updateDeck(
    const QString& title,
    const QString& subtitle,
    bool enabled)
{
    if (m_selectedDeckId < 0)
        return;

    if (!m_pRepository->UpdateDeck(m_selectedDeckId, title, subtitle, enabled))
        return;

    loadDecks();

    emit selectedDeckChanged();
}

void PolyQ::FlashcardController::deleteDecks(const QVariantList& deckIds)
{
    if (deckIds.isEmpty())
        return;

    std::vector<int> ids;
    ids.reserve(deckIds.size());

    bool containsCurrent = false;

    for (const QVariant& value : deckIds)
    {
        const int id = value.toInt();

        ids.push_back(id);
        containsCurrent |= id == m_selectedDeckId;
    }

    if (!m_pRepository->DeleteDecks(ids))
        return;

    loadDecks();

    if (!containsCurrent)
        return;

    m_selectedDeckId = -1;
    m_cardModel.setCards({});
    startReviewSession(-1);

    emit selectedDeckChanged();
    emit cardChanged();
    emit showingAnswerChanged();
    emit reviewProgressChanged();
    emit canContinueReviewChanged();
}

void PolyQ::FlashcardController::createCard(const QString& front, const QString& back, const QStringList& answers)
{
    if (m_selectedDeckId < 0)
        return;

    const QString trimmedFront = front.trimmed();
    const QString trimmedBack = back.trimmed();

    if (trimmedFront.isEmpty() || trimmedBack.isEmpty())
        return;

    Flashcard card;
    card.deckId = m_selectedDeckId;
    card.front = trimmedFront;
    card.back = trimmedBack;
    card.acceptedAnswers = normalizedAnswers(answers, trimmedBack);

    if (!m_pRepository->CreateCard(card))
        return;

    loadCards(m_selectedDeckId);
    startReviewSession(m_selectedDeckId);
    loadDecks();

    emit selectedDeckChanged();
    emit cardChanged();
    emit showingAnswerChanged();
    emit reviewProgressChanged();
    emit canContinueReviewChanged();
}

void PolyQ::FlashcardController::updateCard(
    int cardId,
    const QString& front,
    const QString& back,
    const QStringList& answers)
{
    if (m_selectedDeckId < 0)
        return;

    const QString trimmedFront = front.trimmed();
    const QString trimmedBack = back.trimmed();

    if (trimmedFront.isEmpty() || trimmedBack.isEmpty())
        return;

    std::optional<Flashcard> existingCard;

    for (int i = 0; i < m_cardModel.count(); ++i)
    {
        Flashcard card = m_cardModel.cardAt(i);

        if (card.id == cardId)
        {
            existingCard = card;
            break;
        }
    }

    if (!existingCard.has_value())
        return;

    Flashcard card = existingCard.value();
    card.front = trimmedFront;
    card.back = trimmedBack;
    card.acceptedAnswers = normalizedAnswers(answers, trimmedBack);

    if (!m_pRepository->UpdateCard(card))
        return;

    loadCards(m_selectedDeckId);
    startReviewSession(m_selectedDeckId);
    loadDecks();

    emit selectedDeckChanged();
    emit cardChanged();
    emit showingAnswerChanged();
    emit reviewProgressChanged();
    emit canContinueReviewChanged();
}

void PolyQ::FlashcardController::deleteCards(const QVariantList& cardIds)
{
    if (m_selectedDeckId < 0 || cardIds.isEmpty())
        return;

    std::vector<int> ids;
    ids.reserve(cardIds.size());

    for (const QVariant& value : cardIds)
        ids.push_back(value.toInt());

    if (!m_pRepository->DeleteCards(ids))
        return;

    loadCards(m_selectedDeckId);
    startReviewSession(m_selectedDeckId);
    loadDecks();
    refreshSelectedDeck();

    emit cardChanged();
    emit selectedDeckChanged();
    emit showingAnswerChanged();
    emit reviewProgressChanged();
    emit canContinueReviewChanged();
}

void PolyQ::FlashcardController::reviewCard(ReviewRating rating)
{
    const ReviewResult result = m_reviewSession.SubmitRating(rating);

    applyReviewResult(result);
}

void PolyQ::FlashcardController::applyReviewResult(const ReviewResult& result)
{
    setReviewFeedback(result);

    if (result.shouldPersist())
    {
        const Flashcard& updatedCard = result.updatedCard.value();

        if (m_pRepository->UpdateCard(updatedCard))
        {
            m_cardModel.updateCard(updatedCard);
            refreshSelectedDeck();
        }
    }

    emit reviewProgressChanged();
    emit canContinueReviewChanged();
}

void PolyQ::FlashcardController::loadCards(int deckId)
{
    if (deckId < 0)
    {
        m_cardModel.setCards({});
        return;
    }

    m_cardModel.setCards(m_pRepository->GetCardsForDeck(deckId));
}

void PolyQ::FlashcardController::startReviewSession(int deckId)
{
    std::vector<Flashcard> cards;

    if (deckId >= 0)
    {
        switch (m_reviewSettings.mode)
        {
        case ReviewSessionMode::AllCards:
            cards = m_pRepository->GetCardsForDeck(deckId);
            break;

        case ReviewSessionMode::SpacedRepetition:
            cards = m_pRepository->GetDueCardsForDeck(deckId);
            break;
        }
    }

    m_reviewSession.Start(cards, m_reviewSettings);

    m_cardIndex = m_reviewSession.HasCards() ? 0 : -1;
    m_showingAnswer = false;

    resetReviewFeedback();
    setLastAnswerState(0);

    emit cardChanged();
    emit showingAnswerChanged();
    emit canContinueReviewChanged();
}

void PolyQ::FlashcardController::updateCurrentCardFromSession()
{
    m_showingAnswer = false;

    resetReviewFeedback();
    setLastAnswerState(0);

    if (!m_reviewSession.HasCards())
        m_cardIndex = -1;
    else
        ++m_cardIndex;

    emit cardChanged();
    emit showingAnswerChanged();
    emit selectedDeckChanged();
    emit reviewProgressChanged();
    emit canContinueReviewChanged();
}

void PolyQ::FlashcardController::refreshSelectedDeck()
{
    if (m_selectedDeckId < 0)
        return;

    const auto deck = m_pRepository->GetDeckById(m_selectedDeckId);

    if (!deck.has_value())
        return;

    m_deckModel.updateDeck(deck.value());

    emit selectedDeckChanged();
}

void PolyQ::FlashcardController::resetReviewFeedback()
{
    if (!m_showReviewFeedback
        && m_lastReviewRatingText.isEmpty()
        && m_lastReviewDueText.isEmpty())
    {
        return;
    }

    m_showReviewFeedback = false;
    m_lastReviewRatingText.clear();
    m_lastReviewDueText.clear();

    emit lastReviewFeedbackChanged();
}

void PolyQ::FlashcardController::setLastAnswerState(int state)
{
    if (m_lastAnswerState == state)
        return;

    m_lastAnswerState = state;

    emit lastAnswerStateChanged();
}

void PolyQ::FlashcardController::setReviewFeedback(const ReviewResult& result)
{
    if (result.type == ReviewResultType::None)
    {
        resetReviewFeedback();
        return;
    }

    m_lastReviewRatingText = ratingToText(result.rating);

    if (result.updatedCard.has_value())
        m_lastReviewDueText = dueText(result.updatedCard->dueAt);
    else if (result.wasRequeued())
        m_lastReviewDueText = QStringLiteral("Try again in this session");
    else
        m_lastReviewDueText.clear();

    m_showReviewFeedback = true;

    emit lastReviewFeedbackChanged();
}

QStringList PolyQ::FlashcardController::normalizedAnswers(const QStringList& answers, const QString& mainAnswer)
{
    QStringList result;
    QSet<QString> seen;

    const QString mainKey = mainAnswer.trimmed().toCaseFolded();

    for (const QString& answer : answers)
    {
        const QString trimmed = answer.trimmed();
        const QString key = trimmed.toCaseFolded();

        if (trimmed.isEmpty())
            continue;

        if (key == mainKey)
            continue;

        if (seen.contains(key))
            continue;

        seen.insert(key);
        result.push_back(trimmed);
    }

    return result;
}

QString PolyQ::FlashcardController::ratingToText(ReviewRating rating)
{
    switch (rating)
    {
    case ReviewRating::Again:
        return QStringLiteral("Again");

    case ReviewRating::Hard:
        return QStringLiteral("Hard");

    case ReviewRating::Good:
        return QStringLiteral("Good");

    case ReviewRating::Easy:
        return QStringLiteral("Easy");
    }

    return {};
}

QString PolyQ::FlashcardController::dueText(const QDateTime& dueAt)
{
    if (!dueAt.isValid())
        return {};

    const QDateTime now = QDateTime::currentDateTimeUtc();
    const qint64 seconds = now.secsTo(dueAt);

    if (seconds <= 0)
        return QStringLiteral("Due now");

    if (seconds < 60)
        return QStringLiteral("Next review in less than a minute");

    const qint64 minutes = seconds / 60;

    if (minutes < 60)
        return QStringLiteral("Next review in %1 minute%2")
        .arg(minutes)
        .arg(minutes == 1 ? QString() : QStringLiteral("s"));

    const qint64 hours = minutes / 60;

    if (hours < 24)
        return QStringLiteral("Next review in %1 hour%2")
        .arg(hours)
        .arg(hours == 1 ? QString() : QStringLiteral("s"));

    const qint64 days = hours / 24;

    return QStringLiteral("Next review in %1 day%2")
        .arg(days)
        .arg(days == 1 ? QString() : QStringLiteral("s"));
}