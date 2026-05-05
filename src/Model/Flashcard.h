#pragma once

#include <QString>

namespace PolyQ
{
    struct Flashcard
    {
        int id = -1;
        int deckId = -1;

        QString front;
        QString back;
    };
}