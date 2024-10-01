require "rails_helper"

RSpec.describe "Transactions API", type: :request do
  let(:user) { create(:user) }

  describe "POST /transactions" do
    context "with valid parameters" do
      it "creates a new USD to BTC transaction" do
        allow(BtcPriceService).to receive(:current_price).and_return(40000.00)

        transaction_params = {
          user_id: user.id,
          currency_sent: "USD",
          currency_received: "BTC",
          amount_sent: 2000.00
        }

        expect {
          post "/transactions", params: transaction_params
        }.to change(Transaction, :count).by(1)

        expect(response).to have_http_status(:created)
        json = JSON.parse(response.body)
        expect(json["amount_sent"]).to eq("2000.00")
        expect(json["amount_received"]).to eq("0.05000000") # 2000 / 40000
        expect(json["currency_sent"]).to eq("USD")
        expect(json["currency_received"]).to eq("BTC")
      end

      it "updates the user balance correctly" do
        allow(BtcPriceService).to receive(:current_price).and_return(40000.00)

        transaction_params = {
          user_id: user.id,
          currency_sent: "USD",
          currency_received: "BTC",
          amount_sent: 2000.00
        }

        post "/transactions", params: transaction_params

        user.reload
        expect(user.balance_usd).to eq(8000.00) # 10000 - 2000
        expect(user.balance_btc).to eq(1.05000000) # 1 + 0.05
      end
    end

    context "with insufficient balance" do
      it "does not create the transaction and returns an error" do
        user.update(balance_usd: 1000.00)

        transaction_params = {
          user_id: user.id,
          currency_sent: "USD",
          currency_received: "BTC",
          amount_sent: 2000.00
        }

        expect {
          post "/transactions", params: transaction_params
        }.not_to change(Transaction, :count)

        expect(response).to have_http_status(:unprocessable_entity)
        json = JSON.parse(response.body)
        expect(json["error"]).to eq("Insufficient balance")
      end
    end
  end

  describe "GET /users/:user_id/transactions" do
    it "returns the transactions of the user" do
      create_list(:transaction, 5, user: user)

      get "/users/#{user.id}/transactions"

      expect(response).to have_http_status(:success)
      json = JSON.parse(response.body)
      expect(json.length).to eq(5)
    end
  end

  describe 'GET /transactions/:id' do
    let(:transaction) { create(:transaction, user: user) }

    it 'returns the details of the transaction' do
      get "/transactions/#{transaction.id}"

      expect(response).to have_http_status(:success)
      json = JSON.parse(response.body)
      expect(json['id']).to eq(transaction.id)
      expect(json['currency_sent']).to eq(transaction.currency_sent)
      expect(json['amount_sent']).to eq(sprintf('%.2f', transaction.amount_sent))
    end

    it 'returns an error if the transaction does not exist' do
      get '/transactions/9999'

      expect(response).to have_http_status(:not_found)
      json = JSON.parse(response.body)
      expect(json['error']).to eq('Transaction not found')
    end
  end
end
