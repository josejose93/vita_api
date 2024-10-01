class CreateTransactions < ActiveRecord::Migration[7.2]
  def change
    create_table :transactions do |t|
      t.references :user, null: false, foreign_key: true
      t.string :currency_sent
      t.string :currency_received
      t.decimal :amount_sent
      t.decimal :amount_received

      t.timestamps
    end
  end
end
