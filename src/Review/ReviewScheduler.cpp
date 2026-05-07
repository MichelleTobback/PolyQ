#include "ReviewScheduler.h"

#include <algorithm>

PolyQ::Flashcard PolyQ::ReviewScheduler::Schedule(const Flashcard& card, ReviewRating rating) const
{
    Flashcard updated = card;
    updated.reviewCount++;

    switch (rating)
    {
    case ReviewRating::Again:
        updated.intervalDays = 0;
        updated.easeFactor = std::max(1.3, updated.easeFactor - 0.2);
        updated.dueAt = QDateTime::currentDateTimeUtc().addSecs(10 * 60);
        break;

    case ReviewRating::Hard:
        updated.intervalDays = std::max(1, updated.intervalDays);
        updated.easeFactor = std::max(1.3, updated.easeFactor - 0.15);
        updated.dueAt = QDateTime::currentDateTimeUtc().addDays(updated.intervalDays);
        break;

    case ReviewRating::Good:
        updated.intervalDays = updated.reviewCount <= 1
            ? 1
            : std::max(1, static_cast<int>(updated.intervalDays * updated.easeFactor));
        updated.dueAt = QDateTime::currentDateTimeUtc().addDays(updated.intervalDays);
        break;

    case ReviewRating::Easy:
        updated.easeFactor += 0.15;
        updated.intervalDays = updated.reviewCount <= 1
            ? 3
            : std::max(3, static_cast<int>(updated.intervalDays * updated.easeFactor * 1.3));
        updated.dueAt = QDateTime::currentDateTimeUtc().addDays(updated.intervalDays);
        break;
    }

    return updated;
}