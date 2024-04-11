# frozen_string_literal: true

Rails
  .application
  .routes
  .draw do
    namespace :api, defaults: { format: :json } do
      namespace :v1 do
        resources :datasets, only: [:index]
        resources :games, only: %i[index create]
        resources :meanings, only: %i[index create]
        resources :missing_words, only: %i[index create]
        resources :rankings, only: %i[index]
        resources :sms_forwarders, only: %i[create]
        namespace :curura do
          resources :rankings, only: %i[index]
          resources :games, only: %i[create]
        end
      end
    end

    resources :youtubers, only: %i[index show]

    root to: "youtubers#index"
  end
