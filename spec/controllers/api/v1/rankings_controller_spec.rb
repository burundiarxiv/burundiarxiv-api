# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::RankingsController do
  describe 'GET index' do
    it 'renders the ranking the international rank' do
      create(:game, score: 7, country: 'France')
      create(:game, score: 11, country: 'Canada')
      create(:game, score: 12, country: 'Burundi')
      create(:game, score: 15, country: 'France')
      create(:game, score: 17, country: 'Burundi')
      create(:game, score: 18, country: 'Burundi')
      create(:game, score: 19, country: 'Burundi', won: false)
      create(:game, score: 20, country: 'Burundi', solution: 'other')

      get :index,
          params: {
            solution: 'solution',
            country: 'Burundi',
            score: 12,
          },
          format: :json

      expect(JSON.parse(response.body)).to eq(
        {
          'median_international_score' => '15.0',
          'median_national_score' => '17.5',
          'country' => 'Burundi',
          'international_rank' => '5/7',
          'national_rank' => '4/4',
        },
      )
    end
  end
end
