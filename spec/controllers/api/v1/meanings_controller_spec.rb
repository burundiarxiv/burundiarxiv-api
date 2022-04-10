# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::MeaningsController do
  describe 'POST create' do
    it 'creates a new meaning' do
      post :create,
           params: {
             meaning: {
               keyword: 'keyword',
               meaning: 'meaning',
               proverb: 'proverb',
             },
           }
      expect(response).to have_http_status(:success)
      expect(Meaning.count).to eq(1)
      expect(Meaning.last).to have_attributes(
        keyword: 'keyword',
        meaning: 'meaning',
        proverb: 'proverb',
      )
    end
  end

  describe 'GET index' do
    it 'renders the created meanings' do
      create(:meaning)
      create(:meaning, meaning: 'meaning2')
      get :index, format: :json
      expect(JSON.parse(response.body)).to eq(
        {
          'count' => 2,
          'meanings' => [
            {
              'proverb' => 'proverb',
              'keyword' => 'keyword',
              'meanings' => %w[meaning2 meaning],
            },
          ],
        },
      )
    end
  end
end
