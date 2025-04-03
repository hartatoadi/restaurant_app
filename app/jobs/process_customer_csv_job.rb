class ProcessCustomerCsvJob
  include Sidekiq::Worker

  def perform(file_path)
    Customer.import_from_csv(file_path)
  end
end
