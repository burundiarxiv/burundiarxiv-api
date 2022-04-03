# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::RankingsController do
  describe 'GET index' do
    it 'returns the rankings based on score and country' do
      get :index,
          params: {
            score: '10',
            country: 'France',
            solution: 'solution',
          },
          format: :json

      expect(JSON.parse(response.body)).to eq(
        {
          'average_international_score' => 32,
          'average_national_score' => 10,
          'country' => 'France',
          'international_rank' => '3/4',
          'national_rank' => '1/2',
        },
      )
    end

    it 'computes the avg international score' do
      create(:game, score: 7, country: 'France')
      create(:game, score: 11, country: 'Canada')
      create(:game, score: 19, country: 'Burundi')
      create(:game, score: 19, country: 'Burundi', won: false)
      create(:game, score: 20, country: 'Burundi', solution: 'other')

      get :index, params: { solution: 'solution' }, format: :json

      expect(JSON.parse(response.body)['average_international_score']).to eq(
        '12.33',
      )
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
