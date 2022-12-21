require "test_helper"

class FastXlsxReaderTest < Minitest::Test
  def test_version_number
    refute_nil FastXlsxReader::VERSION
  end

  def test_open_file
    puts 'RAM USAGE BEFORE START TEST: ' + `pmap #{Process.pid} | tail -1`[10,40].strip
    samples = Dir.glob(File.join(File.dirname(__FILE__), 'sample', '*.xlsx'))
    samples.each do |sample_file|
      puts "Testing sample #{sample_file}"
      start = Time.now
      reader = FastXlsxReader::Reader.new(sample_file)
      puts "\tRAM USAGE AFTER NEW READER INSTANCE: " + `pmap #{Process.pid} | tail -1`[10,40].strip
      assert reader.file_name != nil
      finish = Time.now
      puts "\tTime to open file #{reader.file_name}: #{elapsed_time(start, finish)}"

      start = Time.now
      reader.each do |row|
        puts "\tHeader: #{row.join(", ")}"
        break
      end
      puts "\tRAM USAGE AFTER FIRST LINE READ: " + `pmap #{Process.pid} | tail -1`[10,40].strip
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
      puts "\tRAM USAGE AFTER READ ENTIRE SPREADSHEET: " + `pmap #{Process.pid} | tail -1`[10,40].strip
      puts "\tTime to read #{rows} rows and #{cols} cells: #{elapsed_time(start, finish)}\n\n"
    end
  end

  def test_invalid_file
    xlsx_example = File.join(File.dirname(__FILE__), 'sample', 'not_found.xlsx')
    assert_raises TypeError do
      ::FastXlsxReader::Reader.new(xlsx_example)
    end
  end

  def elapsed_time(start, finish)
    "#{(finish - start) * 1000.0}ms"
  end
end
