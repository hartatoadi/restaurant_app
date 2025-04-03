class Customer < ApplicationRecord
  #Relationships
  has_many :orders, dependent: :destroy

  #Validations
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true

  #Constants
  MAX_FILE_SIZE = 10.megabytes

  # Scopes
  scope :frequent_loyal_customers, -> {
    joins(:orders)
      .where('orders.placed_at >= :order_time', { order_time: 30.days.ago })
      .group('customers.id')
      .having('COUNT(orders.id) >= 5')
      .preload(:orders)
    }

  class << self
    def valid_csv?(file)
      file.content_type == 'text/csv' || file.original_filename.ends_with?('.csv')
    end

    def valid_file_size?(file)
      file.size <= MAX_FILE_SIZE
    end

    def save_csv(file)
      file_path = Rails.root.join('tmp', "#{SecureRandom.hex}.csv")
      File.open(file_path, 'wb') { |f| f.write(file.read) }
      file_path
    end

    def import_from_csv(file_path)
      begin
        CSV.foreach(file_path, headers: true) do |row|
          process_csv_row(row)
        end
      rescue => e
        Rails.logger.error "Failed to process CSV file: #{file_path}. Error: #{e.message}"
      ensure
        File.delete(file_path) if File.exist?(file_path)
      end
    end

    def process_csv_row(row)
      customer_params = row.to_hash
      customer = Customer.new(customer_params)

      if customer.save
        Rails.logger.info "Customer #{customer.name} imported successfully."
      else
        Rails.logger.error "Failed to import customer: #{customer.errors.full_messages.join(", ")}"
      end
    end
  end
end
