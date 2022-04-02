# frozen_string_literal: true

module Api
  module V1
    class RankingsController < ApplicationController
      def index
        @average_international_score = Game.average(:score).round(2)
      end
    end
  end
end
