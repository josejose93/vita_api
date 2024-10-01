# == Schema Information
#
# Table name: transactions
#
#  id                :bigint           not null, primary key
#  user_id           :bigint           not null
#  currency_sent     :string
#  currency_received :string
#  amount_sent       :decimal(, )
#  amount_received   :decimal(, )
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
class TransactionSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :currency_sent, :currency_received, :amount_sent, :amount_received, :created_at, :updated_at

  def amount_sent
    format_amount(object.amount_sent, object.currency_sent)
  end

  def amount_received
    format_amount(object.amount_received, object.currency_received)
  end

  private

  def format_amount(amount, currency)
    decimals = currency == "USD" ? 2 : 8
    sprintf("%.#{decimals}f", amount)
  end
end
