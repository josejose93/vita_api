# == Schema Information
#
# Table name: users
#
#  id          :bigint           not null, primary key
#  name        :string
#  username    :string
#  balance_usd :decimal(, )
#  balance_btc :decimal(, )
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    username { Faker::Name.name }
    balance_usd { 10_000.00 }
    balance_btc { 1.00000000 }
  end
end
