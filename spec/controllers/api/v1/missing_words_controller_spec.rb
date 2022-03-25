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
      get :index, format: :json

      expect(JSON.parse(response.body)).to eq(
        [{ 'value' => missing_word.value, 'count' => missing_word.count }],
      )
    end

    it 'sorts the list by count' do
      create(:missing_word, value: 'a', count: 1)
      create(:missing_word, value: 'b', count: 2)
      create(:missing_word, value: 'c', count: 3)
      get :index, format: :json

      expect(JSON.parse(response.body)).to eq(
        [
          { 'value' => 'c', 'count' => 3 },
          { 'value' => 'b', 'count' => 2 },
          { 'value' => 'a', 'count' => 1 },
        ],
      )
    end
  end
end
