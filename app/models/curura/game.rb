class Curura::Game < ApplicationRecord
  validates :score, :country, :start_time, presence: true
end
