#pragma once

#include <QString>
#include <QDateTime>

namespace PolyQ
{
    struct Flashcard
    {
        int id = -1;
        int deckId = -1;

        QString front;
        QString back;

        int reviewCount = 0;
        int intervalDays = 0;
        double easeFactor = 2.5;
        QDateTime dueAt = QDateTime::currentDateTimeUtc();

        bool IsDue(QDateTime time) const
        {
            return dueAt <= time;
        }

        bool IsDue() const
        {
            return IsDue(QDateTime::currentDateTimeUtc());
        }
    };
}