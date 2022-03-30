# frozen_string_literal: true

json.count @count
json.games do
  json.array!(@games) do |game|
    json.extract! game, :country, :guesses, :solution, :time_taken, :won
    json.start_time game.start_time.strftime('%Y-%m-%d %H:%M:%S')
    json.end_time game.end_time.strftime('%Y-%m-%d %H:%M:%S')
  end
end
