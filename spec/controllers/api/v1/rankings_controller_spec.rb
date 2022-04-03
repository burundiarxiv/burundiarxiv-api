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
          },
          format: :json

      expect(JSON.parse(response.body)['average_national_score']).to eq('15.5')
    end

    it 'handles non existing country' do
      get :index,
          params: {
            solution: 'solution',
            country: 'Other',
          },
          format: :json

      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)['average_national_score']).to eq(0)
      expect(JSON.parse(response.body)['average_international_score']).to eq(0)
    end
  end
end

# 10 games from 3 differents countries
# 3 games won in France
# 3 games won in Burundi
# 2 games lost in France
# 2 games lost in Burundi
# 1 game won in France different solution
# 1 game lost in France different solution
# some games won other lost
# some games with another solution
# get ranking
