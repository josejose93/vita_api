#
# Controller for fetching the current BTC price in USD.
#
class PricesController < ApplicationController
  def btc
    price = BtcPriceService.current_price
    if price
      formatted_price = sprintf("%.2f", price)
      render json: { btc_price_usd: formatted_price }, status: :ok
    else
      render json: { error: "Error fetching BTC price" }, status: :service_unavailable
    end
  end
end
