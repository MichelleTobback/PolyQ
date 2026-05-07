#pragma once

#include "../Model/Flashcard.h"

#include <optional>

namespace PolyQ
{
    enum class ReviewRating
    {
        Again = 0,
        Hard = 1,
        Good = 2,
        Easy = 3
    };

    enum class ReviewResultType
    {
        None = 0,
        Rescheduled,
        Requeued,
        EndlessAdvanced
    };

    struct ReviewResult
    {
        ReviewResultType type = ReviewResultType::None;
        ReviewRating rating = ReviewRating::Again;

        std::optional<Flashcard> updatedCard;

        bool shouldPersist() const
        {
            return updatedCard.has_value();
        }

        bool countsAsReviewed() const
        {
            return type == ReviewResultType::Rescheduled
                || type == ReviewResultType::EndlessAdvanced;
        }

        bool wasRequeued() const
        {
            return type == ReviewResultType::Requeued;
        }
    };
}