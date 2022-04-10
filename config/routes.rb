# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :datasets, only: [:index]
      resources :games, only: %i[index create]
      resources :meanings, only: %i[create]
      resources :missing_words, only: %i[index create]
      resources :rankings, only: %i[index]
    end
  end
end
