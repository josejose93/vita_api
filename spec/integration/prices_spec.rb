require 'swagger_helper'

RSpec.describe 'Prices API', type: :request do
  path '/btc_price' do
    get 'Get current BTC price' do
      tags 'Prices'
      produces 'application/json'

      response '200', 'price retrieved' do
        schema '$ref' => '#/components/schemas/BtcPriceResponse'

        before do
          allow(BtcPriceService).to receive(:current_price).and_return(40000.00)
        end

        run_test!
      end

      response '503', 'service unavailable' do
        before do
          allow(BtcPriceService).to receive(:current_price).and_return(nil)
        end

        run_test!
      end
    end
  end
end
