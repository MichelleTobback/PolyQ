#include "ReviewSession.h"

void PolyQ::ReviewSession::Start(std::vector<Flashcard> cards, const ReviewSessionSettings& settings)
{
    m_settings = settings;
	m_queue.clear();

	for (const Flashcard& card : cards)
		m_queue.push_back(card);

	m_reviewedCount = 0;
	m_totalCount = static_cast<int>(cards.size());

    m_statistics = {};
}

void PolyQ::ReviewSession::Clear()
{
	m_queue.clear();
}

bool PolyQ::ReviewSession::HasCards() const
{
	return !m_queue.empty();
}

int PolyQ::ReviewSession::RemainingCount() const
{
	return static_cast<int>(m_queue.size());
}

std::optional<PolyQ::Flashcard> PolyQ::ReviewSession::CurrentCard() const
{
	if (m_queue.empty())
		return std::nullopt;

	return m_queue.front();
}

int PolyQ::ReviewSession::ReviewedCount() const
{
    return m_reviewedCount;
}

int PolyQ::ReviewSession::TotalCount() const
{
    return m_totalCount;
}

bool PolyQ::ReviewSession::CanContinue() const
{
    switch (m_settings.mode)
    {
    case ReviewSessionMode::AllCards:
        return true;
        break;

    case ReviewSessionMode::SpacedRepetition:
        break;
    }
    return false;
}

const PolyQ::ReviewSessionStatistics& PolyQ::ReviewSession::GetStatistics() const
{
    return m_statistics;
}

PolyQ::ReviewResult PolyQ::ReviewSession::SubmitAnswer(const QString& answer)
{
    if (m_queue.empty())
        return {};

    const AnswerCheckResult answerResult = m_validator.Check(answer, CurrentCard()->back, m_settings.validation);

    ReviewResult result = SubmitRating(answerResult.suggestedRating);
    result.answerResult = answerResult;

    return result;
}

PolyQ::ReviewResult PolyQ::ReviewSession::SubmitRating(ReviewRating rating)
{
    if (m_queue.empty())
        return {};

    Flashcard current = m_queue.front();
    m_queue.pop_front();

    if (m_settings.mode == ReviewSessionMode::AllCards)
    {
        m_queue.push_back(current);

        if (m_totalCount > 0)
            m_reviewedCount = (m_reviewedCount + 1) % m_totalCount;

        ReviewResult result;
        result.type = ReviewResultType::EndlessAdvanced;
        result.rating = rating;
        return result;
    }

    switch (rating)
    {
    case ReviewRating::Again: ++m_statistics.againCount; break;
    case ReviewRating::Hard:  ++m_statistics.hardCount; break;
    case ReviewRating::Good:  ++m_statistics.goodCount; break;
    case ReviewRating::Easy:  ++m_statistics.easyCount; break;
    }

    if (rating == ReviewRating::Again)
    {
        m_queue.push_back(current);

        ReviewResult result;
        result.type = ReviewResultType::Requeued;
        result.rating = rating;
        return result;
    }

    Flashcard updated = m_scheduler.Schedule(current, rating);

    ReviewResult result;
    result.type = ReviewResultType::Rescheduled;
    result.rating = rating;
    result.updatedCard = updated;

    ++m_reviewedCount;

    return result;
}
