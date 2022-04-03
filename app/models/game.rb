# frozen_string_literal: true

class Game < ApplicationRecord
  before_save :compute_score, if: :should_compute_score?

  scope :won, -> { where(won: true) }
  scope :solution, ->(solution) { where(solution: solution) }
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
    won.solution(solution).average(:score).round(2)
  end

  def self.average_national_score(solution, country)
    won.solution(solution).country(country).average(:score).round(2)
  end

  private

  def should_compute_score?
    score.zero? && time_taken.present? && time_taken < 24.hours.seconds.to_i
  end
end
