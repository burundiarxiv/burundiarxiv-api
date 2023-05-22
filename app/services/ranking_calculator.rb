class RankingCalculator
  class << self
    def call(games_with_solution:, games_won_with_solution:, score:, country:)
      @games_with_solution = games_with_solution
      @games_won_with_solution = games_won_with_solution
      @score = score
      @country = country

      [international_rank, national_rank]
    end

    private

    def international_rank
      return "-" if @games_with_solution.count.zero?

      position = @games_won_with_solution.where("score >= ?", @score).count
      position = position.zero? ? 1 : position
      "#{position}/#{@games_with_solution.count}"
    end

    def national_rank
      games = @games_with_solution.country(@country)
      return "-" if games.count.zero?

      position = @games_won_with_solution.country(@country).where("score >= ?", @score).count
      position = position.zero? ? 1 : position
      "#{position}/#{games.count}"
    end
  end
end
