# frozen_string_literal: true

module FastXlsx
  ##
  # The `FastXlsx::Writer` class provides a high-level Ruby interface
  # for writing `.xlsx` files using the native `FastXlsxWriter` backend.
  # It supports efficient streaming-style writing of rows and cells.
  #
  # Example usage:
  #
  #   writer = FastXlsx::Writer.new("output.xlsx")
  #   writer.add_column("Name")
  #   writer.add_column("Age")
  #
  #   writer.next_row
  #   writer.add_cell("Alice")
  #   writer.add_cell(30)
  #
  #   writer.next_row
  #   writer.add_cell("Bob")
  #   writer.add_cell(28)
  #
  #   writer.close
  #
  #
  class Writer
    ##
    # Creates a new Writer for the given `.xlsx` file.
    #
    # @param file [String] the path to the output `.xlsx` file
    def initialize(file)
      file_path = File.absolute_path(file)
      @native_writer = FastXlsxWriter.new(file_path)
    end

    ##
    # Starts a new row in the spreadsheet.
    #
    # Must be called before adding cells to a new row.
    #
    # @return [void]
    def next_row
      @native_writer.next_row
    end

    ##
    # Adds a cell with the given content to the current row.
    #
    # Automatically converts non-string values to string, and treats `nil` as an empty string.
    #
    # @param content [Object] the content to write in the cell
    # @return [void]
    def add_cell(content)
      parsed_content =
        case content
        when String then content
        when nil then ""
        else content.to_s
        end
      @native_writer.add_cell(parsed_content)
    end

    ##
    # Adds a column header with an optional width.
    #
    # This method is intended to be called before any rows are added.
    #
    # @param content [String] the column name or header
    # @param width [Integer] the width of the column (default: 16)
    # @return [void]
    def add_column(content, width: 16)
      @native_writer.add_column(content, width)
    end

    ##
    # Closes the writer and flushes the contents to disk.
    #
    # This must be called to finalize and save the `.xlsx` file.
    #
    # @return [void]
    def close
      @native_writer.close
    end
  end
end
