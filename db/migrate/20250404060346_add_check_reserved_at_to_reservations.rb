class AddCheckReservedAtToReservations < ActiveRecord::Migration[8.0]
  def change
    reversible do |dir|
      dir.up do
        execute <<-SQL
          ALTER TABLE reservations
          ADD CONSTRAINT check_reserved_at_future
          CHECK (reserved_at > NOW() + INTERVAL '1 hour')
        SQL
      end

      dir.down do
        execute <<-SQL
          ALTER TABLE reservations
          DROP CONSTRAINT IF EXISTS check_reserved_at_future
        SQL
      end
    end
  end
end
