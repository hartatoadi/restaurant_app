class Order < ApplicationRecord
  # Relationships
  belongs_to :customer

  # Enumerations
  enum :order_state, { pending: 0, preparing: 1, ready: 2, delivered: 3 }

  # Validations
  validates :total_price, presence: true, numericality: { greater_than: 0 }
  validates :order_state, :placed_at, presence: true

  #Scope
  scope :by_order_state, ->(state) { where(order_state: state) if state.present? }
end
