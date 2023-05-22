# frozen_string_literal: true

class Game < ApplicationRecord
  before_save :compute_score, if: :should_compute_score?

  scope :country, ->(country) { where(country: country) }
  scope :latest, -> { where(start_time: (Time.current - 1.day)..(Time.current + 1.day)) }
  scope :with_solution, ->(solution) { latest.where(solution: solution) }
  scope :won_above_score, ->(score) { where("score >= ?", score) }
  scope :won_with_solution, ->(solution) { won.with_solution(solution) }
  scope :won, -> { where(won: true) } # take into account start_time at 1970

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

  private

  def should_compute_score?
    score.zero? && time_taken.present? && acceptable_time_taken?
  end

  def acceptable_time_taken?
    time_taken < 24.hours.seconds.to_i
  end
end
