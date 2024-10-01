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
class User < ApplicationRecord
  has_many :transactions, dependent: :destroy

  validates :name, presence: true
  validates :username, presence: true, uniqueness: true
  validates :balance_usd, :balance_btc, numericality: { greater_than_or_equal_to: 0 }
end
