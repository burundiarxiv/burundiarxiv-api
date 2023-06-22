class RankingCalculator
  class << self
    def call(games_with_solution:, games_won_with_solution:, score:, country:)
      @games_with_solution = games_with_solution
      @games_won_with_solution = games_won_with_solution
      @score = score
      @country = country

      { international_rank: international_rank, national_rank: national_rank }
    end

    private

    def international_rank
      return "-" if @games_with_solution.empty?

      position = @games_won_with_solution.won_above_score(@score).count.nonzero? || 1
      "#{position}/#{@games_with_solution.size}"
    end

    def national_rank
      games = @games_with_solution.country(@country)
      return "-" if games.empty?
      position =
        @games_won_with_solution.country(@country).won_above_score(@score).count.nonzero? || 1

      "#{position}/#{games.size}"
    end
  end
end
