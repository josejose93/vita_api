#
# This controller is responsible for handling the transactions
#
class TransactionsController < ApplicationController
  before_action :set_user, only: [:create, :user_transactions]
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def create
    service = TransactionService.new(user: @user, params: transaction_params)
    result = service.call

    if result[:success]
      render json: result[:transaction], status: :created
    else
      render json: { error: result[:error] }, status: :unprocessable_entity
    end
  end

  def user_transactions
    transactions = @user.transactions
    render json: transactions, status: :ok
  end

  def show
    transaction = Transaction.find(params[:id])
    render json: transaction, status: :ok
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end

  def transaction_params
    params.permit(:currency_sent, :currency_received, :amount_sent)
  end

  def record_not_found
    render json: { error: "Transaction not found" }, status: :not_found
  end
end
