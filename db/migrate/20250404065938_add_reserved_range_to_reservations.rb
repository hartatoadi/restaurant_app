class AddReservedRangeToReservations < ActiveRecord::Migration[8.0]
  def change
    add_column :reservations, :reserved_range, :tstzrange

    reversible do |dir|
      dir.up do
        execute <<-SQL
          UPDATE reservations
          SET reserved_range = tstzrange(now(), now(), '[]')
          WHERE reserved_range IS NULL;
        SQL

        execute <<-SQL
          ALTER TABLE reservations
          ALTER COLUMN reserved_range
          SET DEFAULT tstzrange(now(), now(), '[]');
        SQL

        execute <<-SQL
          ALTER TABLE reservations
          ALTER COLUMN reserved_range
          SET NOT NULL;
        SQL
      end
    end
  end
end
