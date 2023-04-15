# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::MissingWordsController do
  describe 'POST create' do
    it 'responds 200' do
      post :create, params: { word: { value: 'test' } }
      expect(response).to have_http_status(:success)
    end

    it 'creates a new missing word' do
      expect { post :create, params: { word: { value: 'test' } } }.to change(MissingWord, :count)
        .by(1)
    end

    it 'sets the count at 1 for a new missing word' do
      post :create, params: { word: { value: 'test' } }
      expect(MissingWord.last.count).to eq(1)
    end
  end

  describe 'GET index' do
    it 'responds 200' do
      get :index, format: :json
      expect(response).to have_http_status(:success)
    end

    it 'returns a list of missing words' do
      create(:missing_word)
      get :index, format: :json
      expect(JSON.parse(response.body)).to eq(
        { 'count' => 1, 'missing_words' => [{ 'value' => 'test', 'count' => 1 }] },
      )
    end

    it 'sorts the list by count' do
      create(:missing_word, value: 'a', count: 1)
      create(:missing_word, value: 'b', count: 2)
      create(:missing_word, value: 'c', count: 3)
      get :index, format: :json

      expect(JSON.parse(response.body)).to eq(
        {
          'count' => 3,
          'missing_words' => [
            { 'value' => 'c', 'count' => 3 },
            { 'value' => 'b', 'count' => 2 },
            { 'value' => 'a', 'count' => 1 },
          ],
        },
      )
    end

    it 'sorts the list by count then by value' do
      create(:missing_word, value: 'a', count: 1)
      create(:missing_word, value: 'b', count: 4)
      create(:missing_word, value: 'c', count: 4)
      create(:missing_word, value: 'd', count: 4)
      get :index, format: :json

      expect(JSON.parse(response.body)).to eq(
        {
          'count' => 4,
          'missing_words' => [
            { 'value' => 'b', 'count' => 4 },
            { 'value' => 'c', 'count' => 4 },
            { 'value' => 'd', 'count' => 4 },
            { 'value' => 'a', 'count' => 1 },
          ],
        },
      )
    end
  end
end
