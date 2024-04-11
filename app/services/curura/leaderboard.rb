module Curura
  class Leaderboard
    class << self
      def call(games:)
        @games = games

        { best_players: best_players, players_by_country: players_by_country }
      end

      private

      def best_players
        @games
          .order(score: :desc)
          .limit(10)
          .map
          .with_index(1) { |game, rank| { rank: rank, score: game.score, country: game.country } }
      end

      def players_by_country
        @games
          .group_by(&:country)
          .transform_values(&:count)
          .sort_by { |country, count| [-count, country] }
          .first(10)
          .map
          .with_index(1) { |(country, count), rank| { rank: rank, country: country, count: count } }
      end
    end
  end
end
