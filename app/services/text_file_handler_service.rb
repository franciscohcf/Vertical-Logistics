class TextFileHandlerService
  attr_reader :file_path

  def initialize(file_path)
    @file_path = file_path
  end

  def call
    raise StandardError, 'Empty File.' if File.empty?(file_path)

    File.read(file_path)
  end
end
