#pragma once

#include "../Model/Flashcard.h"

#include "ReviewScheduler.h"

#include <deque>
#include <optional>
#include <vector>

namespace PolyQ
{
    class ReviewSession final
    {
    public:
        void Start(std::vector<Flashcard> cards);
        void Clear();

        bool HasCards() const;
        int RemainingCount() const;
        int ReviewedCount() const;
        int TotalCount() const;

        std::optional<Flashcard> CurrentCard() const;

        std::optional<Flashcard> SubmitRating(ReviewRating rating);

    private:
        std::deque<Flashcard> m_queue;
        ReviewScheduler m_scheduler;

        int m_reviewedCount = 0;
        int m_totalCount = 0;
    };
}