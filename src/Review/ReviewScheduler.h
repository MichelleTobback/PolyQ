#pragma once

#include "../Model/Flashcard.h"

#include "ReviewResult.h"

namespace PolyQ
{
    class ReviewScheduler final
    {
    public:
        Flashcard Schedule(const Flashcard& card, ReviewRating rating) const;
    };
}