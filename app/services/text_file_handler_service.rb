class TextFileHandlerService
  attr_reader :file

  def initialize(file)
    @file = file
  end

  def call
    raise StandardError, 'Empty File.' if File.empty?(file)

    File.read(file)
  end
end
