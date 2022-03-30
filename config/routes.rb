# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :datasets, only: [:index]
      resources :missing_words, only: %i[index create]
      resources :games, only: %i[index create]
    end
  end
end
