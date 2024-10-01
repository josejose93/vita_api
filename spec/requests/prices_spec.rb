require "rails_helper"

RSpec.describe "Prices API", type: :request do
  describe "GET /btc_price" do
    it "returns the current BTC price in USDD" do
      allow(BtcPriceService).to receive(:current_price).and_return(40000.00)

      get "/btc_price"

      expect(response).to have_http_status(:success)
      json = JSON.parse(response.body)
      expect(json["btc_price_usd"]).to eq("40000.00")
    end

    it "handles errors when the BTC price cannot be retrieved" do
      allow(BtcPriceService).to receive(:current_price).and_return(nil)

      get "/btc_price"

      expect(response).to have_http_status(:service_unavailable)
      json = JSON.parse(response.body)
      expect(json["error"]).to eq("Error fetching BTC price")
    end
  end
end
