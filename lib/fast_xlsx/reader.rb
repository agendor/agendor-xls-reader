# frozen_string_literal: true

module FastXlsx
  class Reader
    def initialize(file)
      file_path = File.absolute_path(file)
      @native_reader = FastXlsxReader.new(file_path)
    end

    def file_name
      @native_reader.file_name
    end

    def each(max_rows: nil, &block)
      @native_reader.read_values(max_rows, &block)
    end

    def headers
      @headers ||= @native_reader.get_headers
    end

    def close
      @native_reader.close
    end
  end
end
