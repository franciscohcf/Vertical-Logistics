class DataParserService
  attr_reader :entry

  def initialize(entry)
    @entry = entry
  end

  def call
    parse_data
  end

  private

  def parse_data
    raise StandardError, 'Invalid entry. This process requires a specific ledger entry format.' unless validate_parttern

    {
      user_id: formated_user_id,
      name: formated_user_name,
      order_id: formated_order_id,
      product_id: formated_product_id,
      value: formated_product_value,
      date: formated_date(entry[87..])
    }
  end

  def formated_user_id
    entry[0..9].to_i
  end

  def formated_user_name
    entry[10..54].strip
  end

  def formated_order_id
    entry[55..64].to_i
  end

  def formated_product_id
    entry[65..74].to_i
  end

  def formated_product_value
    entry[75..86].to_f
  end

  def formated_date(date_str)
    "#{date_str[0..3]}-#{date_str[4..5]}-#{date_str[6..7]}"
  end

  def validate_parttern
    entry&.match?(/^\d{10}\s+.+?\d{10}\d{10}\s+\s*\d+\.?\d*\d{8}$/)
  end
end
