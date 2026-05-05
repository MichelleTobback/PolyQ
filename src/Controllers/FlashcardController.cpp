#include "FlashcardController.h"

PolyQ::FlashcardController::FlashcardController(QObject* parent)
    : QObject(parent)
{
    m_cards = {
        { "la pomme", "the apple" },
        { "le chat", "the cat" },
        { "merci", "thank you" }
    };

    std::vector<Deck> decks = {
        { 1, "French Basics", "3 cards due today", 3, true },
        { 2, "Portuguese Starter", "Coming soon", 0, false },
        { 3, "Russian - English", "Coming soon", 0, false },
        { 5, "Dutch - English", "Coming soon", 0, false },
        { 6, "English - Dutch", "Coming soon", 0, false },
        { 7, "Japanese - English", "Coming soon", 0, false }
    };

    m_DeckModel.setDecks(std::move(decks));
}

QString PolyQ::FlashcardController::front() const
{
    if (m_cards.isEmpty())
        return {};
    return m_cards[m_cardIndex].front;
}

QString PolyQ::FlashcardController::back() const
{
    if (m_cards.isEmpty())
        return {};
    return m_cards[m_cardIndex].back;
}

bool PolyQ::FlashcardController::showingAnswer() const
{
    return m_showingAnswer;
}

int PolyQ::FlashcardController::cardIndex() const
{
    return m_cardIndex;
}

int PolyQ::FlashcardController::cardCount() const
{
    return m_cards.size();
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

void PolyQ::FlashcardController::reviewCard(int rating)
{
    Q_UNUSED(rating);

    nextCard();
}

void PolyQ::FlashcardController::nextCard()
{
    if (m_cards.isEmpty())
        return;

    m_cardIndex = (m_cardIndex + 1) % m_cards.size();
    m_showingAnswer = false;

    emit cardChanged();
    emit showingAnswerChanged();
}