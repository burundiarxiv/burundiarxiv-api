# frozen_string_literal: true

class Game < ApplicationRecord
  before_save :compute_score, if: :should_compute_score?

  scope :latest, -> { where(start_time: (Time.current - 1.day)..(Time.current + 1.day)) }
  scope :won, -> { where(won: true) } # take into account start_time at 1970
  scope :with_solution, ->(solution) { latest.where(solution: solution) }
  scope :won_with_solution, ->(solution) { won.with_solution(solution) }
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
    games = won_with_solution(solution)
    return 0 if games.count.zero?

    games.median(:score).round(2).to_s.gsub(/(\d)(?=(\d\d\d)+(?!\d))/, '\\1 ')
  end

  def self.median_national_score(solution:, country:)
    games = won_with_solution(solution).country(country)
    return 0 if games.count.zero?

    games.median(:score).round(2).to_s.gsub(/(\d)(?=(\d\d\d)+(?!\d))/, '\\1 ')
  end

  def self.international_rank(solution:, score:)
    games = with_solution(solution)
    return 0 if games.count.zero?

    position = won_with_solution(solution).where('score >= ?', score).count
    position = position.zero? ? 1 : position
    "#{position}/#{games.count}"
  end

  def self.national_rank(solution:, country:, score:)
    games = with_solution(solution).country(country)
    return 0 if with_solution(solution).country(country).count.zero?

    position = won_with_solution(solution).country(country).where('score >= ?', score).count
    position = position.zero? ? 1 : position
    "#{position}/#{games.count}"
  end

  def self.best_players(solution:)
    games = won_with_solution(solution)
    games
      .order(score: :desc)
      .limit(10)
      .map
      .with_index { |game, rank| { rank: rank + 1, score: game.score, country: game.country } }
  end

  def self.players_by_country(solution:)
    games = with_solution(solution)
    games
      .group(:country)
      .count
      .sort_by { |_country, count| -count }
      .first(5)
      .map
      .with_index { |(country, count), rank| { rank: rank + 1, country: country, count: count } }
  end

  private

  def should_compute_score?
    score.zero? && time_taken.present? && acceptable_time_taken?
  end

  def acceptable_time_taken?
    time_taken < 24.hours.seconds.to_i
  end
end
