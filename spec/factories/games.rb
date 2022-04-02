# frozen_string_literal: true

FactoryBot.define do
  factory :game do
    solution { 'solution' }
    guesses { %w[guess-1 guess-2] }
    won { false }
    start_time { Time.current }
    end_time { 10.minutes.from_now }
    country { 'France' }
    time_taken { 10 }
    timezone { 'Europe/Paris' }
  end
end
