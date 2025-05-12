# frozen_string_literal: true

module FastXlsx
  ##
  # The `FastXlsx::Reader` class provides a high-level Ruby wrapper
  # around the native `FastXlsxReader`, allowing you to read `.xlsx` files
  # efficiently in a streaming fashion.
  #
  # Example usage:
  #
  #   reader = FastXlsx::Reader.new("path/to/file.xlsx")
  #   puts reader.file_name
  #
  #   reader.each do |row|
  #     puts row.inspect
  #   end
  #
  #   reader.close
  #
  class Reader
    ##
    # Creates a new Reader for the given `.xlsx` file.
    #
    # @param file [String] the path to the `.xlsx` file
    def initialize(file)
      file_path = File.absolute_path(file)
      @native_reader = FastXlsxReader.new(file_path)
    end

    ##
    # Returns the name of the file being read.
    #
    # @return [String] the file name
    def file_name
      @native_reader.file_name
    end

    ##
    # Iterates over each row in the spreadsheet.
    #
    # The first row (representing headers) is ignored.
    #
    # @param max_rows [Integer, nil] (optional) maximum number of rows to read
    # @yieldparam row [Array<String>] a row from the spreadsheet
    # @return [void]
    def each(max_rows: nil, &block)
      @native_reader.read_values(max_rows, &block)
    end

    ##
    # Returns the header row of the spreadsheet.
    #
    # @return [Array<String>] the column headers
    def headers
      @headers ||= @native_reader.get_headers
    end

    ##
    # Closes the underlying native reader and releases resources.
    #
    # @return [void]
    def close
      @native_reader.close
    end
  end
end
