#pragma once

#include <QString>

namespace PolyQ
{
    struct Deck
    {
        QString title;
        QString subtitle;
        int id = -1;
        int cardCount = 0;
        int dueCount = 0;
        bool enabled = true;
    };
}