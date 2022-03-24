# frozen_string_literal: true

module Api
  module V1
    class DatasetsController < ApplicationController
      def index
        datasets = JSON.parse(File.read("public/datasets.json"))

        render json: datasets
      end
    end
  end
end
