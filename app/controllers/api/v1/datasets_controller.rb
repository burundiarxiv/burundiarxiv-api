class Api::V1::DatasetsController < ApplicationController

  def index
    datasets = JSON.parse(File.read('public/datasets.json'))

    render json: datasets
  end
end
