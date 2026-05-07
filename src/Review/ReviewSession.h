#pragma once

#include "../Model/Flashcard.h"

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

    class ReviewSession final
    {
    public:
        void Start(std::vector<Flashcard> cards, const ReviewSessionSettings& settings);
        void Clear();

        bool HasCards() const;
        int RemainingCount() const;
        int ReviewedCount() const;
        int TotalCount() const;

        std::optional<Flashcard> CurrentCard() const;

        std::optional<Flashcard> SubmitRating(ReviewRating rating);

    private:
        ReviewSessionSettings m_settings{};
        std::deque<Flashcard> m_queue;
        ReviewScheduler m_scheduler{};

        int m_reviewedCount = 0;
        int m_totalCount = 0;
    };
}