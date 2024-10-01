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
class Transaction < ApplicationRecord
  belongs_to :user

  validates :currency_sent, :currency_received, :amount_sent, :amount_received, presence: true
  validates :amount_sent, :amount_received, numericality: { greater_than: 0 }
end
