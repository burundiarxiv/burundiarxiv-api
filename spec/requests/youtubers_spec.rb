require "rails_helper"

RSpec.describe "Youtubers", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get youtubers_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "returns http success" do
      create(:youtuber)
      get youtuber_path(Youtuber.first)
      expect(response).to have_http_status(:success)
    end
  end
end
