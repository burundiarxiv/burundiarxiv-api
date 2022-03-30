# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::GamesController do
  describe 'POST create' do
    it 'creates a new game with specific parameters' do
      post :create,
           params: {
             game: {
               guesses: %w[AMATA UMUTI INSWA],
               solution: 'INSWA',
               won: true,
               start_time: '2022-03-29T23:13:10.174Z',
               end_time: '2022-03-29T23:14:30.597Z',
               time_taken: 80,
               country: 'France',
             },
           }

      expect(response).to have_http_status(:success)
      game = Game.last
      expect(game.guesses).to eq %w[AMATA UMUTI INSWA]
      expect(game.solution).to eq 'INSWA'
      expect(game.won).to eq true
      expect(game.start_time).to eq '2022-03-29T23:13:10.174Z'
      expect(game.end_time).to eq '2022-03-29T23:14:30.597Z'
      expect(game.time_taken).to eq 80
      expect(game.country).to eq 'France'
    end
  end

  describe 'GET index' do
    it 'displays the games of the day' do
      start_time = Time.current
      end_time = 10.minutes.from_now
      game = create(:game, start_time: start_time, end_time: end_time)
      get :index, format: :json

      expect(JSON.parse(response.body)).to eq(
        {
          'count' => 1,
          'games' => [
            {
              'country' => game.country,
              'guesses' => game.guesses,
              'solution' => game.solution,
              'time_taken' => game.time_taken,
              'won' => game.won,
              'start_time' => start_time.strftime('%Y-%m-%d %H:%M:%S'),
              'end_time' => end_time.strftime('%Y-%m-%d %H:%M:%S'),
            },
          ],
        },
      )
    end
  end
end
