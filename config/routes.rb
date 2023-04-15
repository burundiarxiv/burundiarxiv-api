# frozen_string_literal: true

Rails.application.routes.draw do
  get '/home/index', to: 'home#index'
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :datasets, only: [:index]
      resources :games, only: %i[index create]
      resources :meanings, only: %i[index create]
      resources :missing_words, only: %i[index create]
      resources :rankings, only: %i[index]
      resources :sms_forwarders, only: %i[create]
    end
  end

  root 'home#index'
end
