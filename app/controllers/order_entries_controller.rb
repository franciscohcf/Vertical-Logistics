class OrderEntriesController < ApplicationController
  def create
    unless valid_upload?
      return render_error('No file uploaded', :bad_request) if params[:file].blank?

      return render_error('Only text files are accepted', :bad_request)
    end

    process_file
  rescue StandardError => e
    render_error(e.message, :unprocessable_entity)
  end

  private

  def valid_upload?
    params[:file].present? && params[:file].content_type == 'text/plain'
  end

  def process_file
    start_time = Time.current

    OrderProcessingService.new(params[:file].tempfile.path).call

    processing_time = (Time.current - start_time).round(2)

    render json: {
      message: 'Order entries processed successfully',
      processing_time: processing_time
    }, status: :ok
  end

  def render_error(message, status)
    render json: { error: message }, status: status
  end
end
