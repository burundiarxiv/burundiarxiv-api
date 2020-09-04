Rails.application.routes.draw do
  get '/.well-known/acme-challenge/:id' => 'pages#letsencrypt'

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :datasets, only: [ :index ]
    end
  end
end
