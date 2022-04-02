# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::RankingsController do
  describe 'GET index' do
    it 'returns the rankings based on score and country' do
      get :index, params: { score: '10', country: 'France' }, format: :json

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
  end
end
