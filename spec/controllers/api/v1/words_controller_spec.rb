# frozen_string_literal: true

require "rails_helper"

RSpec.describe Api::V1::WordsController do
  describe "POST create" do
    it "responds 200" do
      post :create, params: {word: {value: "test"}}
      # expect(response.has_http_status?(:success)).to be(true)
      # expect(response).to have_status?(:created)
      expect(response).to have_http_status(:success)

      # expect(Word.count).to eq(1)
      # expect(Word.last.value).to eq('test')
    end
  end
end
