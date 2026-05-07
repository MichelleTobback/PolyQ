#include "ReviewScheduler.h"

#include <algorithm>

PolyQ::Flashcard PolyQ::ReviewScheduler::Schedule(const Flashcard& card, ReviewRating rating) const
{
    Flashcard updated = card;
    updated.reviewCount++;

    const bool isNewCard = updated.intervalDays <= 0;

    switch (rating)
    {
    case ReviewRating::Again:
        updated.intervalDays = 0;
        updated.easeFactor = std::max(1.3, updated.easeFactor - 0.2);
        updated.dueAt = QDateTime::currentDateTimeUtc().addSecs(1 * 60);
        break;

    case ReviewRating::Hard:
        updated.easeFactor = std::max(1.3, updated.easeFactor - 0.15);

        if (isNewCard)
        {
            updated.intervalDays = 0;
            updated.dueAt = QDateTime::currentDateTimeUtc().addSecs(5 * 60);
        }
        else
        {
            updated.intervalDays = std::max(1, static_cast<int>(updated.intervalDays * 1.2));
            updated.dueAt = QDateTime::currentDateTimeUtc().addDays(updated.intervalDays);
        }

        break;

    case ReviewRating::Good:
        if (isNewCard)
        {
            updated.intervalDays = 0;
            updated.dueAt = QDateTime::currentDateTimeUtc().addSecs(10 * 60);
        }
        else
        {
            updated.intervalDays = std::max(
                1,
                static_cast<int>(updated.intervalDays * updated.easeFactor)
            );

            updated.dueAt = QDateTime::currentDateTimeUtc().addDays(updated.intervalDays);
        }

        break;

    case ReviewRating::Easy:
        updated.easeFactor += 0.15;

        updated.intervalDays = updated.reviewCount <= 1
            ? 1
            : std::max(
                2,
                static_cast<int>(updated.intervalDays * updated.easeFactor * 1.3)
            );

        updated.dueAt = QDateTime::currentDateTimeUtc().addDays(updated.intervalDays);

        break;
    }

    return updated;
}