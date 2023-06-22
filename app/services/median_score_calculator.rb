class MedianScoreCalculator
  THOUSANDS_SEPARATOR_REGEX = /(\d)(?=(\d\d\d)+(?!\d))/

  class << self
    def call(games:, country:)
      @games = games

      { international_score: international_score, national_score: national_score(country: country) }
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
      games.median(:score).round.to_s.gsub(THOUSANDS_SEPARATOR_REGEX, '\\1 ')
    end
  end
end
