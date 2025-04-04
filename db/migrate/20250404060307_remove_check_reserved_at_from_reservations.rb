class RemoveCheckReservedAtFromReservations < ActiveRecord::Migration[8.0]
  def change
    execute <<-SQL
      ALTER TABLE reservations
      DROP CONSTRAINT IF EXISTS check_reserved_at_future
    SQL
  end
end
