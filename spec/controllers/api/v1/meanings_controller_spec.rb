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
end
