#include "ReviewSession.h"

void PolyQ::ReviewSession::Start(std::vector<Flashcard> cards)
{
	m_queue.clear();

	for (const Flashcard& card : cards)
		m_queue.push_back(card);

	m_reviewedCount = 0;
	m_totalCount = static_cast<int>(cards.size());
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

std::optional<PolyQ::Flashcard> PolyQ::ReviewSession::SubmitRating(ReviewRating rating)
{
    if (m_queue.empty())
        return std::nullopt;

    Flashcard current = m_queue.front();
    m_queue.pop_front();

    Flashcard updated = m_scheduler.Schedule(current, rating);

    if (rating == ReviewRating::Again)
    {
        m_queue.push_back(updated);
    }
    else
    {
        m_reviewedCount = std::min(++m_reviewedCount, m_totalCount);
    }

    return updated;
}
