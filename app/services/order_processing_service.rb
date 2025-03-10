class OrderProcessingService
  attr_reader :file_path

  def initialize(file_path)
    @file_path = file_path
  end

  def call
    file_content = read_file

    file_content.each_line do |line|
      record_order(parse_line(line))
    end
  end

  private

  def read_file
    TextFileHandlerService.new(file_path).call
  end

  def parse_line(line)
    DataParserService.new(line).call
  end

  def record_order(order_data)
    OrderRecorderService.new(order_data).call
  end
end
