Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  post '/order_entries', to: 'order_entries#create'

  get '/orders', to: 'orders#index'
  get '/orders/:id', to: 'orders#show'
end
