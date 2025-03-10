require 'rails_helper'

RSpec.describe OrderProcessingService do
  describe '#call' do
    it 'calls the services in the correct order with proper parameters' do
      file_path = 'path/to/file.txt'
      file_content = '0000000046                                Vanetta Bogan00000004950000000003      158.6420210620'
      parsed_data = { user_id: 46, name: 'Vanetta Bogan', order_id: 495, product_id: 3, value: 158.64, date: '2021-06-20' }

      text_handler = instance_spy(TextFileHandlerService)
      data_parser = instance_spy(DataParserService)
      order_recorder = instance_spy(OrderRecorderService)

      allow(TextFileHandlerService).to receive(:new).with(file_path).and_return(text_handler)
      allow(text_handler).to receive(:call).and_return(file_content)

      allow(DataParserService).to receive(:new).with(file_content.strip).and_return(data_parser)
      allow(data_parser).to receive(:call).and_return(parsed_data)

      allow(OrderRecorderService).to receive(:new).with(parsed_data).and_return(order_recorder)

      service = described_class.new(file_path)
      service.call

      expect(text_handler).to have_received(:call)
      expect(data_parser).to have_received(:call)
      expect(order_recorder).to have_received(:call)
    end
  end
end
