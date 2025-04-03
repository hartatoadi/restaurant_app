class CustomersController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:import_csv]
  before_action :validate_csv_file, only: [:import_csv]

  def import_csv
    file_path = Customer.save_csv(@file)
    ProcessCustomerCsvJob.perform_async(file_path.to_s)
    render json: { message: "File uploaded successfully, processing in background" }, status: :ok
  end

  private
  def validate_csv_file
    @file = params[:file]
    unless @file.present?
      render json: { error: "File not provided" }, status: :bad_request
      return
    end
    unless Customer.valid_csv?(@file)
      render json: { error: "Invalid CSV format" }, status: :bad_request
      return
    end
    unless Customer.valid_file_size?(@file)
      render json: { error: "File is too large, maximum 10 Mb!" }, status: :bad_request
      return
    end
  end
end
