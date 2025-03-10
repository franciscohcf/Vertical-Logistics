require 'rails_helper'

RSpec.describe OrderEntriesController, type: :controller do
  describe 'POST #create' do
    let(:file) do
      fixture_file_upload(
        Rails.root.join('spec/fixtures/files/simple_ledger.txt'),
        'text/plain'
      )
    end

    context 'when no file is uploaded' do
      it 'returns a bad request status' do
        post :create

        expect(response).to have_http_status(:bad_request)
        expect(response.parsed_body['error']).to eq('No file uploaded')
      end
    end

    context 'when valid file is uploaded' do
      it 'processes the file and returns success' do
        order_processing_service = instance_spy(OrderProcessingService)
        allow(OrderProcessingService).to receive(:new).with(kind_of(String)).and_return(order_processing_service)

        post :create, params: { file: file }

        expect(OrderProcessingService).to have_received(:new).with(kind_of(String))
        expect(order_processing_service).to have_received(:call)
        expect(response).to have_http_status(:ok)
        expect(response.parsed_body['message']).to eq('Order entries processed successfully')
        expect(response.parsed_body).to have_key('processing_time_seconds')
      end
    end

    context 'when processing raises an error' do
      it 'returns an error response' do
        order_processing_service = instance_double(OrderProcessingService)
        allow(OrderProcessingService).to receive(:new).with(kind_of(String)).and_return(order_processing_service)
        allow(order_processing_service).to receive(:call).and_raise(StandardError.new('Processing error'))

        post :create, params: { file: file }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.parsed_body['error']).to eq('Processing error')
      end
    end
  end
end
