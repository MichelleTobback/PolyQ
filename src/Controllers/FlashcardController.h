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

            Q_PROPERTY(QString front READ front NOTIFY cardChanged)
            Q_PROPERTY(QString back READ back NOTIFY cardChanged)
            Q_PROPERTY(bool showingAnswer READ showingAnswer NOTIFY showingAnswerChanged)
            Q_PROPERTY(int cardIndex READ cardIndex NOTIFY cardChanged)
            Q_PROPERTY(int cardCount READ cardCount CONSTANT)
            Q_PROPERTY(DeckModel* decks READ decks CONSTANT)

            Q_PROPERTY(FlashcardListModel* cards READ cards CONSTANT)
            Q_PROPERTY(int selectedDeckId READ selectedDeckId NOTIFY selectedDeckChanged)

    public:
        explicit FlashcardController(QObject* parent = nullptr);
        virtual ~FlashcardController();

        QString front() const;
        QString back() const;
        bool showingAnswer() const;
        int cardIndex() const;
        int cardCount() const;

        Q_INVOKABLE void showAnswer();

        Q_INVOKABLE void reviewAgain();
        Q_INVOKABLE void reviewHard();
        Q_INVOKABLE void reviewGood();
        Q_INVOKABLE void reviewEasy();

        Q_INVOKABLE void loadDecks();
        Q_INVOKABLE void selectDeck(int deckId);
        Q_INVOKABLE void createDeck(const QString& name);
        Q_INVOKABLE void createCard(const QString& front, const QString& back);

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
        int m_selectedDeckId = 0;
        int m_cardIndex = 0;
        bool m_showingAnswer = false;
        FlashcardListModel m_cardModel;
        DeckModel m_DeckModel;
        std::unique_ptr<class IDeckRepository> m_pRepository;
    };
}