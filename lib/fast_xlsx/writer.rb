# frozen_string_literal: true

module FastXlsx
  class Writer
    def initialize(file)
      file_path = File.absolute_path(file)
      @native_writer = FastXlsxWriter.new(file_path)
    end

    def add_mock_data
      @native_writer.add_mock_data
    end

    def next_row
      @native_writer.next_row
    end

    def add_cell(content)
      @native_writer.add_cell(content)
    end

    def add_column(content, width: 16)
      @native_writer.add_column(content, width)
    end

    def close
      @native_writer.close
    end
  end
end
