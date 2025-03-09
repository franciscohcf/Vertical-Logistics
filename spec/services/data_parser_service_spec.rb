require 'rails_helper'

RSpec.describe DataParserService do
  describe '#call' do
    subject(:parser) { DataParserService.new(order_entry).call }

    let(:order_entry) { '0000000099                                  Junita Jast00000010530000000004      747.9120211027' }
    let(:parsed_line) do
      {
        user_id: 99,
        name: 'Junita Jast',
        order_id: 1053,
        product_id: 4,
        value: 747.91,
        date: '2021-10-27'
      }
    end

    context 'when entry is valid' do
      it 'returns a hash with provided data' do
        expect(parser).to eq parsed_line
      end
    end

    context 'when the entry is invalid' do
      let(:order_entry) { nil }

      it 'returns an error' do
        expect { parser }.to raise_error(StandardError, 'Invalid entry. This process requires a specific ledger entry format.')
      end
    end
  end
end
