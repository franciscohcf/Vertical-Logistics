require 'rails_helper'

RSpec.describe TextFileHandlerService do
  describe '#call' do
    subject(:handler) { TextFileHandlerService.new(file_path) }

    let(:file_path) { Rails.root.join('spec/fixtures/files/simple_ledger.txt') }

    let(:text_content) do
      <<~TEXT
        0000000099                                  Junita Jast00000010530000000004      747.9120211027
        0000000099                                  Junita Jast00000010620000000001      150.0220210416
        0000000003                              Carolann Walker00000000270000000000      432.1120210618
        0000000017                              Ethan Langworth00000001770000000005      770.6820210609
        0000000054                                  Edgar Ebert00000005870000000003     1670.7120210829
      TEXT
    end

    context 'when file has content' do
      it 'receives the file' do
        expect(handler.call.strip).to eq text_content.strip
      end
    end

    context 'when file is empty' do
      let(:file_path) { Rails.root.join('spec/fixtures/files/empty.txt') }

      it 'returns an error' do
        expect { handler.call }.to raise_error(StandardError, 'Empty File.')
      end
    end
  end
end
