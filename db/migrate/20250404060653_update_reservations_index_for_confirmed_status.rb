class UpdateReservationsIndexForConfirmedStatus < ActiveRecord::Migration[8.0]
  def change
    reversible do |dir|
      dir.up do
        execute <<-SQL
          DROP INDEX IF EXISTS index_reservations_on_table_and_time;
        SQL

        execute <<-SQL
          CREATE UNIQUE INDEX index_reservations_on_table_and_time_when_confirmed
          ON reservations (table_number, reserved_at)
          WHERE status = 1;
        SQL
      end

      dir.down do
        execute <<-SQL
          DROP INDEX IF EXISTS index_reservations_on_table_and_time_when_confirmed;
        SQL

        execute <<-SQL
          CREATE UNIQUE INDEX index_reservations_on_table_and_time
          ON reservations (table_number, reserved_at);
        SQL
      end
    end
  end
end
