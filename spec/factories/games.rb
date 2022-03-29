# frozen_string_literal: true

FactoryBot.define do
  factory :game do
    solution { 'solution' }
    guesses { %w[guess-1 guess-2] }
    won { false }
    start_time { '2022-03-30 01:17:50' }
    end_time { '2022-03-30 01:18:50' }
    country { 'France' }
    time_taken { 1 }
  end
end
