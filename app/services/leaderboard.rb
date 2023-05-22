class Leaderboard
  class << self
    def call(games_with_solution:, games_won_with_solution:)
      @games_with_solution = games_with_solution
      @games_won_with_solution = games_won_with_solution

      { best_players: best_players, players_by_country: players_by_country }
    end

    private

    def best_players
      @games_won_with_solution
        .order(score: :desc)
        .limit(10)
        .map
        .with_index(1) { |game, rank| { rank: rank, score: game.score, country: game.country } }
    end

    def players_by_country
      @games_with_solution
        .group_by(&:country)
        .transform_values(&:count)
        .sort_by { |country, count| [-count, country] }
        .first(10)
        .map
        .with_index(1) { |(country, count), rank| { rank: rank, country: country, count: count } }
    end
  end
end
