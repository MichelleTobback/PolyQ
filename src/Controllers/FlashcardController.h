#pragma once

#include <QObject>
#include <QString>
#include <QVariantMap>
#include <QVariantList>
#include <QTimer>
#include <memory>

#include "../Model/Flashcard.h"
#include "../ViewModel/FlashcardListModel.h"
#include "../ViewModel/DeckModel.h"
#include "../Review/ReviewSession.h"

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

            Q_PROPERTY(int reviewMode READ reviewMode NOTIFY reviewModeChanged)
            Q_PROPERTY(int reviewedCount READ reviewedCount NOTIFY reviewProgressChanged)
            Q_PROPERTY(int reviewTotalCount READ reviewTotalCount NOTIFY reviewProgressChanged)

    public:
        explicit FlashcardController(QObject* parent = nullptr);
        ~FlashcardController() override;

        QVariantMap currentCard() const;
        QVariantMap currentDeck() const;
        bool showingAnswer() const;
        int cardIndex() const;

        DeckModel* decks() { return &m_DeckModel; }
        FlashcardListModel* cards() { return &m_cardModel; }
        int selectedDeckId() const { return m_selectedDeckId; }

        int reviewMode() const { return static_cast<int>(m_reviewSettings.mode); }
        int reviewedCount() const { return m_reviewSession.ReviewedCount(); }
        int reviewTotalCount() const { return m_reviewSession.TotalCount(); }

        Q_INVOKABLE void showAnswer();

        Q_INVOKABLE void startDueReview();
        Q_INVOKABLE void startEndlessReview();

        Q_INVOKABLE void reviewAgain();
        Q_INVOKABLE void reviewHard();
        Q_INVOKABLE void reviewGood();
        Q_INVOKABLE void reviewEasy();

        Q_PROPERTY(bool reviewFinished READ reviewFinished NOTIFY reviewProgressChanged)
        Q_PROPERTY(int reviewAgainCount READ reviewAgainCount NOTIFY reviewProgressChanged)
        Q_PROPERTY(int reviewHardCount READ reviewHardCount NOTIFY reviewProgressChanged)
        Q_PROPERTY(int reviewGoodCount READ reviewGoodCount NOTIFY reviewProgressChanged)
        Q_PROPERTY(int reviewEasyCount READ reviewEasyCount NOTIFY reviewProgressChanged)

        Q_INVOKABLE void loadDecks();
        Q_INVOKABLE void selectDeck(int deckId);
        Q_INVOKABLE void createDeck(const QString& name);
        Q_INVOKABLE void updateDeck(const QString& title, const QString& subtitle, bool enabled);
        Q_INVOKABLE void deleteDecks(const QVariantList& deckIds);
        Q_INVOKABLE void createCard(const QString& front, const QString& back);
        Q_INVOKABLE void updateCard(int cardId, const QString& front, const QString& back);
        Q_INVOKABLE void deleteCards(const QVariantList& cardIds);

    signals:
        void cardChanged();
        void showingAnswerChanged();
        void selectedDeckChanged();
        void reviewProgressChanged();
        void reviewModeChanged();

    private:
        void reviewCard(int rating);
        void loadCards(int deckId);
        void startReviewSession(int deckId);
        void updateCurrentCardFromSession();
        void refreshSelectedDeck();

        bool reviewFinished() const;
        int reviewAgainCount() const { return m_reviewSession.GetStatistics().againCount; }
        int reviewHardCount() const { return m_reviewSession.GetStatistics().hardCount; }
        int reviewGoodCount() const { return m_reviewSession.GetStatistics().goodCount; }
        int reviewEasyCount() const { return m_reviewSession.GetStatistics().easyCount; }

    private:
        int m_selectedDeckId = -1;
        int m_cardIndex = -1;
        bool m_showingAnswer = false;

        QTimer m_dueRefreshTimer;

        FlashcardListModel m_cardModel;
        DeckModel m_DeckModel;

        std::unique_ptr<class IDeckRepository> m_pRepository;
        ReviewSession m_reviewSession{};
        ReviewSessionSettings m_reviewSettings{};
    };
}