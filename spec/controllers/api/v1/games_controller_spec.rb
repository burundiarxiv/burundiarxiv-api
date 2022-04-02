# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::GamesController do
  describe 'POST create' do
    it 'creates a new game with specific parameters' do
      post :create,
           params: {
             game: {
               country: 'France',
               end_time: '2022-03-30T01:27:57+02:00Z',
               guesses: %w[AMATA UMUTI INSWA],
               score: 70,
               solution: 'INSWA',
               start_time: '2022-03-30T01:25:57+02:00Z',
               time_taken: 80,
               timezone: 'Europe/Paris',
               won: true,
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
      expect(game.score).to eq 70
    end

    it 'computes score when game score is a default value of 0' do
      post :create,
           params: {
             game: {
               country: 'France',
               end_time: '2022-03-30T01:27:57+02:00Z',
               guesses: %w[AMATA UMUTI INSWA],
               start_time: '2022-03-30T01:25:57+02:00Z',
               time_taken: 80,
             },
           }

      expect(response).to have_http_status(:success)
      expect(Game.last.score).to eq 240
    end
  end

  describe 'GET index' do
    it 'displays all created games' do
      game = create(:game)
      get :index, format: :json

      expect(JSON.parse(response.body)).to eq(
        {
          'count' => 1,
          'games' => [
            {
              'country' => game.country,
              'end_time' => game.end_time.to_s,
              'guesses' => game.guesses,
              'id' => game.id,
              'score' => game.score,
              'solution' => game.solution,
              'start_time' => game.start_time.to_s,
              'time_taken' => game.time_taken,
              'timezone' => game.timezone,
              'won' => game.won,
            },
          ],
        },
      )
    end

    it 'orders the games by id in descending order' do
      create(:game, id: 1)
      create(:game, id: 2)
      create(:game, id: 3)

      get :index, format: :json

      expect(
        JSON.parse(response.body)['games'].map { |game| game['id'] },
      ).to eq [3, 2, 1]
    end

    it 'computes score when it is equal to zero' do
      game = create(:game, guesses: %w[INSWA UMUTI AMATA], time_taken: 100)
      get :index, format: :json

      expect(JSON.parse(response.body)['games'][0]['score']).to eq(300)
    end
  end
end
