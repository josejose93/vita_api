require 'swagger_helper'

RSpec.describe 'transactions', type: :request do

  path '/transactions' do
    post('Create a new transaction') do
      tags 'Transactions'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :transaction, in: :body, schema: {
        '$ref' => '#/components/schemas/TransactionCreateInput'
      }

      response(201, 'transaction created') do
        schema '$ref' => '#/components/schemas/Transaction'

        let(:user) { create(:user) }
        let(:transaction_params) do
          {
            user_id: user.id,
            currency_sent: 'USD',
            currency_received: 'BTC',
            amount_sent: 2000.00
          }
        end
        let(:transaction) { transaction_params }

        before do
          allow(BtcPriceService).to receive(:current_price).and_return(40000.00)
        end

        run_test!
      end

      response '404', 'invalid request' do
        let(:transaction) { { user_id: -1 } }
        run_test!
      end
    end
  end

  path '/transactions/{id}' do
    get('Get transaction details') do
      tags 'Transactions'
      produces 'application/json'
      parameter name: :id, in: :path, type: :integer, description: 'Transaction ID'

      response '200', 'transactions found' do
        schema '$ref' => '#/components/schemas/Transaction'

        let(:transaction) { create(:transaction) }
        let(:id) { transaction.id }
        run_test!
      end

      response '404', 'transaction not found' do
        let(:id) { -1 }
        run_test!
      end
    end
  end

  path '/users/{user_id}/transactions' do
    get('List transactions of a user') do
      tags 'Transactions'
      produces 'application/json'
      parameter name: 'user_id', in: :path, type: :integer, description: 'User ID'
      response(200, 'transactions found') do
        schema $ref => '#/components/schemas/TransactionList'
        let(:user) { create(:user) }
        let(:user_id) { user.id }

        before do
          create_list(:transaction, 5, user: user)
        end

        run_test!
      end

      response "404", "user not found" do
        let(:user_id) { -1 }
        run_test!
      end
    end
  end
end
