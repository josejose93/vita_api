Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  get "btc_price", to: "prices#btc"
  resources :transactions, only: [:create, :show]
  get "users/:user_id/transactions", to: "transactions#user_transactions"
end
