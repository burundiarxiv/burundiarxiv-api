# frozen_string_literal: true

class Game < ApplicationRecord
  before_save :compute_score, if: :should_compute_score?

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
    score.zero? && time_taken.present? && time_taken < 24.hours.seconds.to_i
  end
end
