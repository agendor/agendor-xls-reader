require "test_helper"

class FastXlsxReaderTest < Minitest::Test
  def test_open_file
    puts "\nRAM USAGE BEFORE START TEST: #{ram_usage}"
    samples = Dir.glob(File.join(File.dirname(__FILE__), "sample", "*.xlsx"))
    samples.each do |sample_file|
      puts "\tTesting sample #{sample_file}"
      start = Time.now
      reader = FastXlsx::Reader.new(sample_file)
      puts "\tRAM USAGE AFTER NEW READER INSTANCE: #{ram_usage}"
      refute_nil reader.file_name
      finish = Time.now
      puts "\tTime to open file #{reader.file_name}: #{elapsed_time(start, finish)}"

      start = Time.now
      reader.each do |row|
        puts "\tHeader: #{row.join(', ')}"
        break
      end
      puts "\tRAM USAGE AFTER FIRST LINE READ: #{ram_usage}"
      finish = Time.now
      puts "\tTime to read first row: #{elapsed_time(start, finish)}"

      start = Time.now
      rows = 0
      cols = 0
      reader.each do |row|
        cols += row.count
        rows += 1
      end
      finish = Time.now
      puts "\tRAM USAGE AFTER READ ENTIRE SPREADSHEET: #{ram_usage}"
      puts "\tTime to read #{rows} rows and #{cols} cells: #{elapsed_time(start, finish)}\n\n"
    end
  end

  def test_invalid_file
    xlsx_example = File.join(File.dirname(__FILE__), "sample", "not_found.xlsx")
    assert_raises TypeError do
      FastXlsx::Reader.new(xlsx_example)
    end
  end

  def test_nested_loops
    sample = File.join(File.dirname(__FILE__), "sample", "data_1mb.xlsx")
    reader = FastXlsx::Reader.new(sample)

    # Only 10 lines, skipping header
    idx = 0
    max = 10
    result_data = []
    header = reader.headers

    reader.each do |row|
      if idx > 0
        result_row = {}
        row.each_with_index do |item, index|
          result_row[header[index]] = item
        end
        result_data << result_row
      end
      idx += 1
      break if idx == max + 1
    end
    result_data.each_with_index { |el, index| puts "#{index} = #{el.inspect}" }

    assert_equal 10, result_data.count
  end

  private

  def elapsed_time(start, finish)
    "#{(finish - start) * 1000.0}ms"
  end

  def ram_usage
    `pmap #{Process.pid} | tail -1`[10, 40].strip
  end
end
