class AddNoDoubleBookingConstraintToReservations < ActiveRecord::Migration[8.0]
  def change
    reversible do |dir|
      dir.up do
        execute <<-SQL
          DROP INDEX IF EXISTS index_reservations_on_table_and_time_when_confirmed;
        SQL

        execute <<-SQL
          DELETE FROM reservations a
          USING reservations b
          WHERE a.id > b.id
          AND a.table_number = b.table_number
          AND a.reserved_range && b.reserved_range
          AND a.status = 1
          AND b.status = 1;
        SQL

        execute <<-SQL
          CREATE EXTENSION IF NOT EXISTS btree_gist;
        SQL

        execute <<-SQL
          ALTER TABLE reservations
          ADD CONSTRAINT no_double_booking
          EXCLUDE USING gist (
            table_number WITH =,
            reserved_range WITH &&
          )
          WHERE (status = 1);
        SQL
      end

      dir.down do
        execute <<-SQL
          ALTER TABLE reservations DROP CONSTRAINT IF EXISTS no_double_booking;
        SQL

        execute <<-SQL
          CREATE UNIQUE INDEX index_reservations_on_table_and_time_when_confirmed
          ON reservations (table_number, reserved_at)
          WHERE status = 1;
        SQL
      end
    end
  end
end
