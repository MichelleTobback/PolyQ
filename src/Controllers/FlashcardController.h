#pragma once

#include <QObject>
#include <QString>
#include <QVector>
#include <memory>

#include "../ViewModel/FlashcardListModel.h"

#include "../Model/Flashcard.h"
#include "../ViewModel/DeckModel.h"

namespace PolyQ
{
    class FlashcardController : public QObject
    {
        Q_OBJECT

            Q_PROPERTY(QVariantMap currentCard READ currentCard NOTIFY cardChanged)
            Q_PROPERTY(QVariantMap currentDeck READ currentDeck NOTIFY selectedDeckChanged)

            Q_PROPERTY(bool showingAnswer READ showingAnswer NOTIFY showingAnswerChanged)
            Q_PROPERTY(int cardIndex READ cardIndex NOTIFY cardChanged)
            Q_PROPERTY(DeckModel* decks READ decks CONSTANT)

            Q_PROPERTY(FlashcardListModel* cards READ cards NOTIFY selectedDeckChanged)
            Q_PROPERTY(int selectedDeckId READ selectedDeckId NOTIFY selectedDeckChanged)

    public:
        explicit FlashcardController(QObject* parent = nullptr);
        virtual ~FlashcardController();

        QVariantMap currentCard() const;
        QVariantMap currentDeck() const;
        bool showingAnswer() const;
        int cardIndex() const;

        Q_INVOKABLE void showAnswer();

        Q_INVOKABLE void reviewAgain();
        Q_INVOKABLE void reviewHard();
        Q_INVOKABLE void reviewGood();
        Q_INVOKABLE void reviewEasy();

        Q_INVOKABLE void loadDecks();
        Q_INVOKABLE void selectDeck(int deckId);
        Q_INVOKABLE void createDeck(const QString& name);
        Q_INVOKABLE void updateDeck(const QString& title, const QString& subtitle, bool enabled);
        Q_INVOKABLE void createCard(const QString& front, const QString& back);
        Q_INVOKABLE void updateCard(int cardId, const QString& front, const QString& back);

        DeckModel* decks() { return &m_DeckModel; }
        FlashcardListModel* cards() { return &m_cardModel; }

        int selectedDeckId() const { return m_selectedDeckId; }

    signals:
        void cardChanged();
        void showingAnswerChanged();

        void selectedDeckChanged();

    private:
        void nextCard();
        void reviewCard(int rating);
        void loadCards(int deckId);

    private:
        int m_selectedDeckId = -1;
        int m_cardIndex = -1;
        bool m_showingAnswer = false;
        FlashcardListModel m_cardModel;
        DeckModel m_DeckModel;
        std::unique_ptr<class IDeckRepository> m_pRepository;
    };
}