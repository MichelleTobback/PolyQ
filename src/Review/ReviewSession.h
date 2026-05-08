#pragma once

#include "../Model/Flashcard.h"

#include "ReviewResult.h"
#include "ReviewScheduler.h"

#include <deque>
#include <optional>
#include <vector>

namespace PolyQ
{
    enum class ReviewSessionMode
    {
        AllCards = 0,
        SpacedRepetition = 1
    };

    struct ReviewSessionSettings
    {
        ReviewSessionMode mode{};
    };

    struct ReviewSessionStatistics
    {
        int againCount = 0;
        int hardCount = 0;
        int goodCount = 0;
        int easyCount = 0;
    };

    class ReviewSession final
    {
    public:
        void Start(std::vector<Flashcard> cards, const ReviewSessionSettings& settings);
        void Clear();

        bool HasCards() const;
        int RemainingCount() const;
        int ReviewedCount() const;
        int TotalCount() const;

        const ReviewSessionStatistics& GetStatistics() const;

        std::optional<Flashcard> CurrentCard() const;

        ReviewResult SubmitRating(ReviewRating rating);

    private:
        ReviewSessionSettings m_settings{};
        std::deque<Flashcard> m_queue;
        ReviewScheduler m_scheduler{};

        int m_reviewedCount = 0;
        int m_totalCount = 0;

        ReviewSessionStatistics m_statistics{};
    };
}