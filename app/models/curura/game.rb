module Curura
  class Game < ApplicationRecord
    validates :score, :country, :start_time, presence: true

    scope :today, -> { where("start_time >= ?", Time.zone.now.beginning_of_day) }
    scope :won_above_score, ->(score) { where("score > ?", score) }
    scope :country, ->(country) { where(country: country) }
  end
end
