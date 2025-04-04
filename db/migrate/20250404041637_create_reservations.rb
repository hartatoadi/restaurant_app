class CreateReservations < ActiveRecord::Migration[8.0]
  def change
    create_table :reservations do |t|
      t.references :customer, null: false, foreign_key: true
      t.integer :table_number
      t.datetime :reserved_at
      t.integer :status, null: false, default: 0

      t.timestamps
    end

    add_index :reservations, [:table_number, :reserved_at], unique: true, name: 'index_reservations_on_table_and_time'

    execute <<-SQL
      ALTER TABLE reservations
      ADD CONSTRAINT check_reserved_at_future
      CHECK (reserved_at > NOW() + INTERVAL '1 hour')
    SQL
  end
end
