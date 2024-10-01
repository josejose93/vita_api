#
# This service is responsible for creating a transaction between two currencies.
#
class TransactionService
  def initialize(user:, params:)
    @user = user
    @currency_sent = params[:currency_sent]
    @currency_received = params[:currency_received]
    @amount_sent = params[:amount_sent]
  end

  def call
    btc_price = BtcPriceService.current_price
    return { error: "Error fetching BTC price" } unless btc_price

    @amount_received = calculate_amount_received(btc_price)
    return { error: "Invalid Coins" } unless @amount_received

    if valid_balance?
      ActiveRecord::Base.transaction do
        update_user_balance
        create_transaction
      end
      { success: true, transaction: @transaction }
    else
      { error: "Insufficient balance" }
    end
  end

  private

  #
  # Calculate the amount received based on the currency sent and received.
  #
  # @param [Float] btc_price The current price of Bitcoin in USD.
  #
  # @return [Float || nil] The amount received in the currency received or nil
  # if the currency is invalid.
  #
  def calculate_amount_received(btc_price)
    if @currency_sent == "USD" && @currency_received == "BTC"
      @amount_sent.to_f / btc_price
    elsif @currency_sent == "BTC" && @currency_received == "USD"
      @amount_sent.to_f * btc_price
    else
      nil
    end
  end

  #
  # Check if the user has enough balance to make the transaction.
  #
  # @return [Boolean] True if the user has enough balance, false otherwise.
  #
  def valid_balance?
    if @currency_sent == "USD"
      @user.balance_usd >= @amount_sent.to_f
    elsif @currency_sent == "BTC"
      @user.balance_btc >= @amount_sent.to_f
    else
      false
    end
  end

  #
  # Update the user balance based on the currency sent and received.
  #
  # @return [User] The updated user.
  #
  def update_user_balance
    if @currency_sent == "USD"
      @user.balance_usd -= @amount_sent.to_f
      @user.balance_btc += @amount_received.to_f
    elsif @currency_sent == "BTC"
      @user.balance_btc -= @amount_sent.to_f
      @user.balance_usd += @amount_received
    end
    @user.save!
  end

  #
  # Create a transaction for the user.
  #
  # @return [Transaction] The created transaction.
  #
  def create_transaction
    @transaction = @user.transactions.create!(
      currency_sent: @currency_sent,
      currency_received: @currency_received,
      amount_sent: @amount_sent,
      amount_received: @amount_received
    )
  end
end
