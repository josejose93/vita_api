Rails.application.routes.draw do
  mount Rswag::Api::Engine => "/api-docs"
  mount Rswag::Ui::Engine => "/api-docs"
  get "up" => "rails/health#show", as: :rails_health_check

  get "btc_price", to: "prices#btc"
  resources :transactions, only: [:create, :show]
  get "users/:user_id/transactions", to: "transactions#user_transactions"
end
