require "fast_xlsx_reader/version"
require "fast_xlsx_reader/fast_xlsx_reader"

module FastXlsxReader

  class Reader

    def initialize(file)
      file_path = File.absolute_path(file)
      @native_reader = FastXlsxInternal::Reader.new(file_path)
    end

    def file_name
      @native_reader.file_name
    end

    def each
      @native_reader.read { |i| yield i }
    end

  end

end
