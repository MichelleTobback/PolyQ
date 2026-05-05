#pragma once

#include <QObject>
#include <QString>
#include <QVector>

#include "../ViewModel/DeckModel.h"

namespace PolyQ
{
    struct Flashcard
    {
        QString front;
        QString back;
    };

    class FlashcardController : public QObject
    {
        Q_OBJECT

            Q_PROPERTY(QString front READ front NOTIFY cardChanged)
            Q_PROPERTY(QString back READ back NOTIFY cardChanged)
            Q_PROPERTY(bool showingAnswer READ showingAnswer NOTIFY showingAnswerChanged)
            Q_PROPERTY(int cardIndex READ cardIndex NOTIFY cardChanged)
            Q_PROPERTY(int cardCount READ cardCount CONSTANT)
            Q_PROPERTY(DeckModel* deckModel READ deckModel CONSTANT)

    public:
        explicit FlashcardController(QObject* parent = nullptr);

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

        DeckModel* deckModel()
        {
            return &m_DeckModel;
        }

    signals:
        void cardChanged();
        void showingAnswerChanged();

    private:
        void nextCard();
        void reviewCard(int rating);

    private:
        QVector<Flashcard> m_cards;
        int m_cardIndex = 0;
        bool m_showingAnswer = false;
        DeckModel m_DeckModel;
    };
}