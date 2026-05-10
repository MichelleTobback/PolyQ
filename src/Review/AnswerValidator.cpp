#include "AnswerValidator.h"

#include <QRegularExpression>
#include <algorithm>
#include <vector>

PolyQ::AnswerCheckResult PolyQ::AnswerValidator::Check(const QString& userAnswer, const QString& correctAnswer, const AnswerValidatorSettings& settings) const
{
    const QString normalizedUser = Normalize(userAnswer, settings);
    const QString normalizedCorrect = Normalize(correctAnswer, settings);

    AnswerCheckResult result{};

    result.editDistance = LevenshteinDistance(normalizedUser, normalizedCorrect);

    const int maxLength = std::max(normalizedUser.length(), normalizedCorrect.length());

    if (maxLength == 0)
    {
        result.similarity = 1.0;
        result.accepted = true;
        return result;
    }

    result.similarity = 1.0 - (result.editDistance / static_cast<double>(maxLength));

    const Thresholds thresholds = GetThresholds(settings.strictness);

    if (result.similarity >= thresholds.easy)
        result.suggestedRating = ReviewRating::Easy;
    else if (result.similarity >= thresholds.good)
        result.suggestedRating = ReviewRating::Good;
    else if (result.similarity >= thresholds.hard)
        result.suggestedRating = ReviewRating::Hard;
    else
        result.suggestedRating = ReviewRating::Again;

    result.accepted = result.suggestedRating > ReviewRating::Hard;

    return result;
}

PolyQ::Thresholds PolyQ::AnswerValidator::GetThresholds(SpellingStrictness strictness) const
{
    static constexpr Thresholds Exact{ .99, 1.0, 1.0 };
    static constexpr Thresholds Forgiving{ .7, .85, .95 };
    static constexpr Thresholds VeryForgiving{ .55, .75, .9 };

    switch (strictness)
    {
    case SpellingStrictness::Exact:
        return Exact;

    case SpellingStrictness::Forgiving:
        return Forgiving;

    case SpellingStrictness::VeryForgiving:
        return VeryForgiving;
    }

    return Forgiving;
}

QString PolyQ::AnswerValidator::Normalize(const QString& text, const AnswerValidatorSettings& settings) const
{
    QString output = text;

    if (settings.trimWhitespace)
        output = output.trimmed();

    if (!settings.caseSensitive)
        output = output.toLower();

    if (settings.ignoreAccents)
    {
        output = output.normalized(QString::NormalizationForm_D);
        output.remove(QRegularExpression(QStringLiteral("\\p{M}+")));
    }

    if (settings.ignorePunctuation)
        output.remove(QRegularExpression(QStringLiteral("[^\\p{L}\\p{N}\\s]")));

    output.replace(QRegularExpression(QStringLiteral("\\s+")), QStringLiteral(" "));

    return output;
}

int PolyQ::AnswerValidator::LevenshteinDistance(const QString& a, const QString& b) const
{
    const int m = a.length();
    const int n = b.length();

    if (m == 0)
        return n;

    if (n == 0)
        return m;

    std::vector<int> previous(n + 1);
    std::vector<int> current(n + 1);

    for (int j = 0; j <= n; ++j)
        previous[j] = j;

    for (int i = 1; i <= m; ++i)
    {
        current[0] = i;

        for (int j = 1; j <= n; ++j)
        {
            const int substitutionCost = a[i - 1] == b[j - 1] ? 0 : 1;

            current[j] = std::min({ previous[j] + 1, current[j - 1] + 1, previous[j - 1] + substitutionCost });
        }

        std::swap(previous, current);
    }

    return previous[n];
}
