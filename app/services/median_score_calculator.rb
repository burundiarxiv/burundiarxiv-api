class MedianScoreCalculator
  class << self
    def call(games:, country:)
      @games = games
      [international_score, national_score(country: country)]
    end

    private

    def international_score
      return "-" if @games.count.zero?

      score(@games)
    end

    def national_score(country:)
      games = @games.country(country)
      return "-" if games.count.zero?

      score(games)
    end

    def score(games)
      games.median(:score).round.to_s.gsub(/(\d)(?=(\d\d\d)+(?!\d))/, '\\1 ')
    end
  end
end
