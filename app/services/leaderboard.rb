class Leaderboard
  class << self
    def call(solution:)
      @solution = solution

      { best_players: best_players, players_by_country: players_by_country }
    end

    private

    def best_players
      Game.best_players(solution: @solution)
    end

    def players_by_country
      Game.players_by_country(solution: @solution)
    end
  end
end
