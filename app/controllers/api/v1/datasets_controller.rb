class Api::V1::DatasetsController < ApplicationController
  def index
    search = params['search']
    datasets = JSON.parse(File.read('public/datasets.json'))

    if search
      datasets = datasets.select { |dataset| dataset['name'].downcase.include? search.downcase }
    end
    render json: datasets
  end
end
