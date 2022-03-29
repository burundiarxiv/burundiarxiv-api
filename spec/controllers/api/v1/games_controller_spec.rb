# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::GamesController do
  describe 'POST create' do
    it 'responds 200' do
      post :create, params: {}
      expect(response).to have_http_status(:success)
    end

    it 'creates a new game' do
      expect { post :create, params: {} }.to change(Game, :count).by(1)
    end
  end
end
