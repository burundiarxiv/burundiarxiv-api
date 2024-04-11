module Curura
  class RankingCalculator
    class << self
      def call(games:, score:, country:)
        @games = games
        @score = score
        @country = country

        { international_rank: international_rank, national_rank: national_rank }
      end

      private

      def international_rank
        return "-" if @games.empty?

        position = @games.won_above_score(@score).count.nonzero? || 1
        "#{position}/#{@games.size}"
      end

      def national_rank
        games = @games.country(@country)
        return "-" if games.empty?
        position = @games.country(@country).won_above_score(@score).count.nonzero? || 1

        "#{position}/#{games.size}"
      end
    end
  end
end
