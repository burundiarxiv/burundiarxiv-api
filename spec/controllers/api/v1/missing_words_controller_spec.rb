# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::MissingWordsController do
  describe 'POST create' do
    it 'responds 200' do
      post :create, params: { word: { value: 'test' } }
      expect(response).to have_http_status(:success)
    end

    it 'creates a new missing word' do
      expect { post :create, params: { word: { value: 'test' } } }.to change(
        MissingWord,
        :count,
      ).by(1)
    end
  end

  describe 'GET index' do
    it 'responds 200' do
      get :index
      expect(response).to have_http_status(:success)
    end

    it 'returns a list of missing words' do
      missing_word = create(:missing_word)
      get :index
      expect(response.body).to include(missing_word.value)
    end
  end
end
