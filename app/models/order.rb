class Order < ApplicationRecord
  # Relationships
  belongs_to :customer

  # Enumerations
  enum :order_state, { pending: 0, processing: 1, completed: 2, canceled: 3 }

  # Validations
  validates :total_price, presence: true, numericality: { greater_than: 0 }
  validates :order_state, :placed_at, presence: true
end
