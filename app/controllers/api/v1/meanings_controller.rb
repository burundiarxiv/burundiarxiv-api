# frozen_string_literal: true

module Api
  module V1
    class MeaningsController < ApplicationController
      def create
        Meaning.create!(meaning_params)
        head :created
      end

      private

      def meaning_params
        params.require(:meaning).permit(:keyword, :meaning, :proverb)
      end
    end
  end
end
