# frozen_string_literal: true

class Game < ApplicationRecord
  before_save :compute_score, if: :should_compute_score?

  scope :won, -> { where(won: true) } # take into account start_time at 1970
  scope :solution, ->(solution) { where(solution: solution) }
  scope :won_with, ->(solution) { won.solution(solution) }
  scope :country, ->(country) { where(country: country) }

  def start_time
    read_attribute(:start_time)&.in_time_zone(timezone)
  end

  def end_time
    read_attribute(:end_time)&.in_time_zone(timezone)
  end

  def compute_score
    return 0 unless won?

    self.score = time_taken * guesses.length
  end

  def self.median_international_score(solution:)
    return 0 if won.solution(solution).count.zero?

    won.solution(solution).median(:score).round(2)
  end

  def self.median_national_score(solution:, country:)
    return 0 if won.solution(solution).count.zero?
    return 0 if won.solution(solution).country(country).count.zero?

    won.solution(solution).country(country).median(:score).round(2)
  end

  def self.international_rank(solution:, score:)
    return 0 if won.solution(solution).count.zero?

    position = won.solution(solution).where('score >= ?', score).count
    position = position.zero? ? 1 : position
    "#{position}/#{won.solution(solution).count}"
  end

  def self.national_rank(solution:, country:, score:)
    return 0 if won.solution(solution).count.zero?
    return 0 if won.solution(solution).country(country).count.zero?

    position =
      won.solution(solution).country(country).where('score >= ?', score).count
    position = position.zero? ? 1 : position
    "#{position}/#{won.solution(solution).country(country).count}"
  end

  private

  def should_compute_score?
    score.zero? && time_taken.present? && acceptable_time_taken?
  end

  def acceptable_time_taken?
    time_taken < 24.hours.seconds.to_i
  end
end
