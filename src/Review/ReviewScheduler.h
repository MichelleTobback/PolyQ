#pragma once

#include "../Model/Flashcard.h"

namespace PolyQ
{
    enum class ReviewRating
    {
        Again = 0,
        Hard = 1,
        Good = 2,
        Easy = 3
    };

    class ReviewScheduler final
    {
    public:
        Flashcard Schedule(const Flashcard& card, ReviewRating rating) const;
    };
}