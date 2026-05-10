#pragma once

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

    enum class SpellingStrictness
    {
        Exact,
        Forgiving,
        VeryForgiving
    };

    struct Thresholds
    {
        double hard;
        double good;
        double easy;
    };
}