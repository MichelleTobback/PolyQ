#pragma once

#include <QString>

namespace PolyQ
{
    struct Deck
    {
        int id = -1;
        QString title;
        QString subtitle;
        int cardCount = 0;
        int dueCount = 0;
        bool enabled = true;
    };
}