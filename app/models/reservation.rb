class Reservation < ApplicationRecord
  # Relationships
  belongs_to :customer

  # Enumerations
  enum :status, { pending: 0, confirmed: 1, cancelled: 2 }

  # Validations
  validates :table_number, :reserved_at, :status, presence: true
  validate :must_be_in_future
  validate :no_double_booking, if: -> { self.confirmed? && self.reserved_at.present? }

  # Scopes
  scope :confirmed_today, -> {
    confirmed
      .where("reserved_range && tstzrange(?, ?)", Time.zone.now.beginning_of_day, Time.zone.now.end_of_day)
      .order(Arel.sql("lower(reserved_range) ASC"))
  }

  #Callbacks
  before_validation :set_default_status, :set_reserved_range, on: :create


  # Custom Save with DB Constraint Handling
  def save_with_handling
    save!
  rescue ActiveRecord::RecordNotUnique, ActiveRecord::StatementInvalid => e
    case e.message
    when /no_double_booking/
      errors.add(:base, "Table #{table_number} is already booked within 2 hours of this time.")
    when /check_reserved_at_future/
      errors.add(:reserved_at, "Reservation must be at least 1 hour from now!")
    else
      raise e
    end
    false
  end

  def set_default_status
    self.status ||= :pending
  end

  def set_reserved_range
    if self.reserved_at.present?
      self.reserved_range = "[#{reserved_at}, #{reserved_at + 2.hours}]"
    end
  end

  private

  def must_be_in_future
    if reserved_at.present? && reserved_at < 1.hour.from_now
      errors.add(:reserved_at, "Reservation must be at least 1 hour from now!")
    end
  end

  def no_double_booking
    overlapping = Reservation.confirmed
                            .where(table_number: table_number)
                            .where.not(id: id)
                            .where("reserved_range && tstzrange(?, ?, '[)')", reserved_at - 2.hours, reserved_at + 2.hours)

    if overlapping.exists?
      errors.add(:reserved_at, "Table #{table_number} is already booked within 2 hours of this time.")
    end
  end
end
