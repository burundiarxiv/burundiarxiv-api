class Api::V1::DatasetsController < ApplicationController
  def index
    @datasets = Dataset.all
    render json: @datasets
  end
end
