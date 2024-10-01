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
class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :balance_usd, :balance_btc

  def balance_usd
    sprintf("%.2f", object.balance_usd)
  end

  def balance_btc
    sprintf("%.8f", object.balance_btc)
  end
end
