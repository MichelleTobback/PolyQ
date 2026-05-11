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
            Q_PROPERTY(int lastAnswerState READ lastAnswerState NOTIFY lastAnswerStateChanged)

            Q_PROPERTY(DeckModel* decks READ decks CONSTANT)
            Q_PROPERTY(FlashcardListModel* cards READ cards NOTIFY selectedDeckChanged)
            Q_PROPERTY(int selectedDeckId READ selectedDeckId NOTIFY selectedDeckChanged)

            Q_PROPERTY(int reviewSessionMode READ reviewSessionMode NOTIFY reviewModeChanged)
            Q_PROPERTY(int reviewInputMode READ reviewInputMode NOTIFY reviewModeChanged)
            Q_PROPERTY(int reviewedCount READ reviewedCount NOTIFY reviewProgressChanged)
            Q_PROPERTY(int reviewTotalCount READ reviewTotalCount NOTIFY reviewProgressChanged)
            Q_PROPERTY(bool reviewFinished READ reviewFinished NOTIFY reviewProgressChanged)

            Q_PROPERTY(int reviewAgainCount READ reviewAgainCount NOTIFY reviewProgressChanged)
            Q_PROPERTY(int reviewHardCount READ reviewHardCount NOTIFY reviewProgressChanged)
            Q_PROPERTY(int reviewGoodCount READ reviewGoodCount NOTIFY reviewProgressChanged)
            Q_PROPERTY(int reviewEasyCount READ reviewEasyCount NOTIFY reviewProgressChanged)

            Q_PROPERTY(bool canContinueReview READ canContinueReview NOTIFY canContinueReviewChanged)

            Q_PROPERTY(QString lastReviewRatingText READ lastReviewRatingText NOTIFY lastReviewFeedbackChanged)
            Q_PROPERTY(QString lastReviewDueText READ lastReviewDueText NOTIFY lastReviewFeedbackChanged)
            Q_PROPERTY(bool showReviewFeedback READ showReviewFeedback NOTIFY lastReviewFeedbackChanged)

    public:
        explicit FlashcardController(QObject* parent = nullptr);
        ~FlashcardController() override;

        QVariantMap currentCard() const;
        QVariantMap currentDeck() const;

        bool showingAnswer() const;
        int cardIndex() const;
        int lastAnswerState() const { return m_lastAnswerState; }

        DeckModel* decks() { return &m_deckModel; }
        FlashcardListModel* cards() { return &m_cardModel; }

        int selectedDeckId() const { return m_selectedDeckId; }

        int reviewSessionMode() const { return static_cast<int>(m_reviewSettings.mode); }
        int reviewInputMode() const { return static_cast<int>(m_reviewSettings.inputMode); }
        int reviewedCount() const { return m_reviewSession.ReviewedCount(); }
        int reviewTotalCount() const { return m_reviewSession.TotalCount(); }

        bool reviewFinished() const;
        bool canContinueReview() const;

        int reviewAgainCount() const { return m_reviewSession.GetStatistics().againCount; }
        int reviewHardCount() const { return m_reviewSession.GetStatistics().hardCount; }
        int reviewGoodCount() const { return m_reviewSession.GetStatistics().goodCount; }
        int reviewEasyCount() const { return m_reviewSession.GetStatistics().easyCount; }

        QString lastReviewRatingText() const { return m_lastReviewRatingText; }
        QString lastReviewDueText() const { return m_lastReviewDueText; }
        bool showReviewFeedback() const { return m_showReviewFeedback; }

        Q_INVOKABLE void checkResults(const QString& userInput);
        Q_INVOKABLE void showAnswer();
        Q_INVOKABLE void nextCard();

        Q_INVOKABLE void startConfiguredReview();
        Q_INVOKABLE void configureReviewSettings(
            int sessionMode,
            int inputMode,
            int strictness,
            bool caseSensitive,
            bool ignoreAccents,
            bool ignorePunctuation
        );

        Q_INVOKABLE void reviewAgain();
        Q_INVOKABLE void reviewHard();
        Q_INVOKABLE void reviewGood();
        Q_INVOKABLE void reviewEasy();

        Q_INVOKABLE void loadDecks();
        Q_INVOKABLE void selectDeck(int deckId);

        Q_INVOKABLE int createDeck(const QString& name);
        Q_INVOKABLE void updateDeck(const QString& title, const QString& subtitle, bool enabled);
        Q_INVOKABLE void deleteDecks(const QVariantList& deckIds);

        Q_INVOKABLE void createCard(const QString& front, const QString& back, const QStringList& answers);
        Q_INVOKABLE void updateCard(int cardId, const QString& front, const QString& back, const QStringList& answers);
        Q_INVOKABLE void deleteCards(const QVariantList& cardIds);

    signals:
        void cardChanged();
        void showingAnswerChanged();
        void selectedDeckChanged();
        void reviewProgressChanged();
        void reviewModeChanged();
        void canContinueReviewChanged();
        void lastAnswerStateChanged();
        void lastReviewFeedbackChanged();

    private:
        void reviewCard(ReviewRating rating);
        void applyReviewResult(const ReviewResult& result);

        void loadCards(int deckId);
        void startReviewSession(int deckId);
        void updateCurrentCardFromSession();
        void refreshSelectedDeck();

        void resetReviewFeedback();
        void setLastAnswerState(int state);
        void setReviewFeedback(const ReviewResult& result);

        QStringList normalizedAnswers(const QStringList& answers, const QString& mainAnswer);

        static QString ratingToText(ReviewRating rating);
        static QString dueText(const QDateTime& dueAt);

    private:
        int m_selectedDeckId = -1;
        int m_cardIndex = -1;

        bool m_showingAnswer = false;
        int m_lastAnswerState = 0;

        QString m_lastReviewRatingText;
        QString m_lastReviewDueText;
        bool m_showReviewFeedback = false;

        QTimer m_dueRefreshTimer;

        FlashcardListModel m_cardModel;
        DeckModel m_deckModel;

        std::unique_ptr<class IDeckRepository> m_pRepository;

        ReviewSession m_reviewSession{};
        ReviewSessionSettings m_reviewSettings{};
    };
}