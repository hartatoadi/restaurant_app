class ChangeReservedRangeToIncludeLowerBound < ActiveRecord::Migration[8.0]
  def change
    change_column :reservations, :reserved_range, :tstzrange, using: "reserved_range::tstzrange"
    change_column_default :reservations, :reserved_range, -> { "tstzrange(now(), now() + interval '2 hours', '[)')" }
  end
end
