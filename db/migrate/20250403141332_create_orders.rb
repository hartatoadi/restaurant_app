class CreateOrders < ActiveRecord::Migration[8.0]
  def change
    create_table :orders do |t|
      t.references :customer, null: false, foreign_key: true
      t.decimal :total_price, default: 0.0, precision: 10, scale: 2
      t.integer :status, null: false
      t.datetime :placed_at

      t.timestamps
    end
  end
end
