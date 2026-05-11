#pragma once
#include "ReviewTypes.h"
#include <QStringList>

namespace PolyQ
{
    struct AnswerValidatorSettings
    {
        bool caseSensitive = false;
        bool trimWhitespace = true;
        bool ignoreAccents = true;
        bool ignorePunctuation = true;
        SpellingStrictness strictness = SpellingStrictness::Forgiving;
    };

    struct AnswerCheckResult
    {
        bool accepted = false;
        double editDistance = 0.0;
        double similarity = 0.0;
        ReviewRating suggestedRating = ReviewRating::Again;
    };

	class AnswerValidator final
	{
	public:
        AnswerCheckResult Check(const QString& userAnswer,
            const QStringList& acceptedAnswers, const AnswerValidatorSettings& settings = {} ) const;

        Thresholds GetThresholds(SpellingStrictness strictness) const;

    private:
        QString Normalize(const QString& text, const AnswerValidatorSettings& settings) const;
        int LevenshteinDistance(const QString& a, const QString& b) const;
	};
}