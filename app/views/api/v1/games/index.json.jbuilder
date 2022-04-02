# frozen_string_literal: true

json.count @count
json.games do
  json.array!(@games) do |game|
    json.extract! game,
                  :country,
                  :guesses,
                  :id,
                  :score,
                  :solution,
                  :time_taken,
                  :timezone,
                  :won
    json.start_time game.start_time.to_s
    json.end_time game.end_time.to_s
  end
end
