# frozen_string_literal: true

class Game < ApplicationRecord
  before_save :compute_score, if: :score_zero?

  def start_time
    read_attribute(:start_time)&.in_time_zone(timezone)
  end

  def end_time
    read_attribute(:end_time)&.in_time_zone(timezone)
  end

  def compute_score
    return if time_taken.nil?

    self.score = time_taken * guesses.length
  end

  private

  def score_zero?
    score.zero?
  end
end
