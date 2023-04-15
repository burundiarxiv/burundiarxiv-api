require 'rails_helper'

RSpec.describe 'Homes', type: :request do
  describe 'GET /index' do
    it 'returns http success' do
      get '/home/index'
      expect(response).to have_http_status(:success)
    end

    it 'renders the index with some data' do
      get '/home/index'
      expect(response.body).to include('Rank')
      expect(response.body).to include('Youtuber')
    end
  end
end
