Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  post '/order_entries', to: 'order_entries#create'

  get 'orders/by_period', to: 'orders#by_period'
  get '/orders/:id', to: 'orders#show'
  get '/orders', to: 'orders#index'
end
