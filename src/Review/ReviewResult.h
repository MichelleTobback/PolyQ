#pragma once

#include "../Model/Flashcard.h"
#include "AnswerValidator.h"
#include "ReviewTypes.h"

#include <optional>

namespace PolyQ
{
    struct ReviewResult
    {
        ReviewResultType type = ReviewResultType::None;
        ReviewRating rating = ReviewRating::Again;

        std::optional<AnswerCheckResult> answerResult;
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