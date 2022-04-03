# frozen_string_literal: true

class Game < ApplicationRecord
  before_save :compute_score, if: :should_compute_score?

  scope :won, -> { where(won: true) }
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

  def self.average_international_score(solution)
    return 0 if won_with(solution).count.zero?

    won_with(solution).average(:score).round(2)
  end

  def self.average_national_score(solution, country)
    return 0 if won_with(solution).count.zero?
    return 0 if won_with(solution).country(country).count.zero?

    won_with(solution).country(country).average(:score).round(2)
  end

  def self.international_rank(solution, score)
    return 0 if won_with(solution).count.zero?

    position = won_with(solution).where('score <= ?', score).count
    "#{position}/#{position + 1}"
  end

  def self.national_rank(solution, country, score)
    return 0 if won_with(solution).count.zero?
    return 0 if won_with(solution).country(country).count.zero?

    position =
      won_with(solution).country(country).where('score <= ?', score).count
    "#{position}/#{position + 1}"
  end

  private

  def should_compute_score?
    score.zero? && time_taken.present? && time_taken < 24.hours.seconds.to_i
  end
end
