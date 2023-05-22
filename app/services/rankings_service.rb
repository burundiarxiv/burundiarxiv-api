class RankingsService
  class << self
    def call(games_with_solution:, games_won_with_solution:, country:, score:)
      median_scores = MedianScoreCalculator.call(games: games_won_with_solution, country: country)
      ranks =
        RankingCalculator.call(
          games_with_solution: games_with_solution,
          games_won_with_solution: games_won_with_solution,
          country: country,
          score: score,
        )
      leaderboard =
        Leaderboard.call(
          games_with_solution: games_with_solution,
          games_won_with_solution: games_won_with_solution,
        )

      median_scores.merge(ranks).merge(leaderboard)
    end
  end
end
