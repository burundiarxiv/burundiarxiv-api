# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::RankingsController do
  describe 'GET index' do
    it 'computes the avg international score' do
      create(:game, score: 7, country: 'France')
      create(:game, score: 11, country: 'Canada')
      create(:game, score: 19, country: 'Burundi')
      create(:game, score: 19, country: 'Burundi', won: false)
      create(:game, score: 20, country: 'Burundi', solution: 'other')

      get :index,
          params: {
            solution: 'solution',
            country: 'France',
            score: 20,
          },
          format: :json

      expect(JSON.parse(response.body)['average_international_score']).to eq(
        '12.33',
      )
    end

    it 'computes the avg national score' do
      create(:game, score: 7, country: 'France')
      create(:game, score: 11, country: 'Canada')
      create(:game, score: 12, country: 'Burundi')
      create(:game, score: 19, country: 'Burundi')
      create(:game, score: 19, country: 'Burundi', won: false)
      create(:game, score: 20, country: 'Burundi', solution: 'other')

      get :index,
          params: {
            solution: 'solution',
            country: 'Burundi',
            score: 12,
          },
          format: :json
      expect(JSON.parse(response.body)['average_national_score']).to eq('15.5')
    end

    it 'handles non existing country' do
      get :index,
          params: {
            solution: 'solution',
            country: 'Other',
            score: 20,
          },
          format: :json

      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)['average_national_score']).to eq(0)
      expect(JSON.parse(response.body)['average_international_score']).to eq(0)
    end

    it 'computes the international rank' do
      create(:game, score: 7, country: 'France')
      create(:game, score: 11, country: 'Canada')
      create(:game, score: 12, country: 'Burundi')
      create(:game, score: 15, country: 'Burundi')
      create(:game, score: 17, country: 'Burundi')
      create(:game, score: 18, country: 'Burundi')
      create(:game, score: 19, country: 'Burundi', won: false)
      create(:game, score: 20, country: 'Burundi', solution: 'other')

      get :index,
          params: {
            solution: 'solution',
            country: 'Burundi',
            score: 17,
          },
          format: :json

      expect(JSON.parse(response.body)['international_rank']).to eq('5/6')
    end

    it 'computes the national rank' do
      create(:game, score: 7, country: 'France')
      create(:game, score: 11, country: 'Canada')
      create(:game, score: 12, country: 'Burundi')
      create(:game, score: 15, country: 'Burundi')
      create(:game, score: 17, country: 'Burundi')
      create(:game, score: 18, country: 'Burundi')
      create(:game, score: 19, country: 'Burundi', won: false)
      create(:game, score: 20, country: 'Burundi', solution: 'other')

      get :index,
          params: {
            solution: 'solution',
            country: 'Burundi',
            score: 17,
          },
          format: :json
      expect(JSON.parse(response.body)['national_rank']).to eq('3/4')
    end
  end
end
