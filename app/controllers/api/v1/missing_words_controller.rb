# frozen_string_literal: true

module Api
  module V1
    class MissingWordsController < ApplicationController
      def index
        render json: MissingWord.all
      end

      def create
        word = MissingWord.find_or_create_by(value: params[:word][:value])
        word.increment!(:count)
        head :created
      end
    end
  end
end
