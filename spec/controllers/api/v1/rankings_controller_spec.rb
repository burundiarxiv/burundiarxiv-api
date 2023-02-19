# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::RankingsController do
  describe 'GET index' do
    it 'renders the ranking the international rank' do
      create(:game, score: 18, country: 'Burundi')
      create(:game, score: 17, country: 'Burundi')
      create(:game, score: 15, country: 'France')
      create(:game, score: 12, country: 'Burundi')
      create(:game, score: 11, country: 'Canada')
      create(:game, score: 7, country: 'France')
      create(:game, score: 19, country: 'Burundi', won: false)
      create(:game, score: 20, country: 'Burundi', solution: 'other')

      get :index, params: { solution: 'solution', country: 'Burundi', score: 12 }, format: :json

      expect(JSON.parse(response.body)).to eq(
        {
          'median_international_score' => '13.5',
          'median_national_score' => '17.0',
          'country' => 'Burundi',
          'international_rank' => '4/7',
          'national_rank' => '3/4',
          'best_players' => [
            { 'rank' => 1, 'score' => 18.0, 'country' => 'Burundi' },
            { 'rank' => 2, 'score' => 17.0, 'country' => 'Burundi' },
            { 'rank' => 3, 'score' => 15.0, 'country' => 'France' },
            { 'rank' => 4, 'score' => 12.0, 'country' => 'Burundi' },
            { 'rank' => 5, 'score' => 11.0, 'country' => 'Canada' },
            { 'rank' => 6, 'score' => 7.0, 'country' => 'France' },
          ],
        },
      )
    end
  end
end
