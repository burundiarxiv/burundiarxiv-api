# frozen_string_literal: true

module Api
  module V1
    class MeaningsController < ApplicationController
      def index
        @meanings = Meaning.order(created_at: :desc).all.group_by(&:proverb)
        @count = Meaning.count
      end

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
