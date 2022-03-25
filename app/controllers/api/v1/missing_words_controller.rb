# frozen_string_literal: true

module Api
  module V1
    class MissingWordsController < ApplicationController
      def index
        @missing_words = MissingWord.all.sort_by(&:count).reverse
      end

      def create
        word = MissingWord.find_or_create_by(value: params[:word][:value])
        word.increment!(:count)
        head :created
      end
    end
  end
end