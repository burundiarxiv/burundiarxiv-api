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
               start_time: '2022-03-30T01:25:57+02:00Z',
               timezone: 'Europe/Paris',
               end_time: '2022-03-30T01:27:57+02:00Z',
               time_taken: 80,
               country: 'France',
             },
           }

      expect(response).to have_http_status(:success)
      game = Game.last
      expect(game.guesses).to eq %w[AMATA UMUTI INSWA]
      expect(game.solution).to eq 'INSWA'
      expect(game.won).to eq true
      expect(game.start_time.to_s).to eq '2022-03-30 01:25:57 +0200'
      expect(game.end_time.to_s).to eq '2022-03-30 01:27:57 +0200'
      expect(game.timezone).to eq 'Europe/Paris'
      expect(game.time_taken).to eq 80
      expect(game.country).to eq 'France'
    end
  end

  describe 'GET index' do
    it 'displays the games of the day' do
      game = create(:game)
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
              'timezone' => game.timezone,
              'start_time' => game.start_time.to_s,
              'end_time' => game.end_time.to_s,
            },
          ],
        },
      )
    end
  end
end