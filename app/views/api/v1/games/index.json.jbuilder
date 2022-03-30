# frozen_string_literal: true

json.count @count
json.games do
  json.array!(@games) do |game|
    json.extract! game,
                  :id,
                  :country,
                  :guesses,
                  :solution,
                  :time_taken,
                  :won,
                  :timezone
    json.start_time game.start_time.to_s
    json.end_time game.end_time.to_s
  end
end
