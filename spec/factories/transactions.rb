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
FactoryBot.define do
  factory :transaction do
    user
    currency_sent { 'USD' }
    currency_received { 'BTC' }
    amount_sent { 1000.00 }
    amount_received { 0.02500000 }
  end
end
