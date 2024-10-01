#
# This service fetches the current price of Bitcoin in USD from the CoinDesk API.
#
class BtcPriceService
  require "net/http"
  require "json"

  def self.current_price
    url = "https://api.coindesk.com/v1/bpi/currentprice.json"
    response = Net::HTTP.get(URI(url))
    data = JSON.parse(response)
    data["bpi"]["USD"]["rate_float"]
  rescue StandardError => e
    Rails.logger.error("Error fetching BTC price: #{e.message}")
    nil
  end
end
