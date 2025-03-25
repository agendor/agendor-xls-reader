# frozen_string_literal: true

require "test_helper"
require "get_process_mem"

class PerformanceTest < Minitest::Test
  def test_benchmark
    sample1 = File.join(File.dirname(__FILE__), "sample", "empresa-6000.xlsx")
    sample2 = File.join(File.dirname(__FILE__), "sample", "empresa-6000-2.xlsx")

    initial_ram_usage = ram_usage
    200.times do |index|
      puts "Iteration ##{index}"
      puts "\tRAM USAGE BEFORE START TEST: #{ram_usage}"
      reader = nil
      with_timer do
        reader = FastXlsx::Reader.new(index.even? ? sample1 : sample2)
      end
      puts "\tRAM USAGE AFTER READ SHEET: #{ram_usage}"

      with_timer do
        reader.headers
      end
      puts "\tRAM USAGE AFTER READ HEADERS: #{ram_usage}"

      items = []
      with_timer do
        reader.each do |row|
          items << row
        end
      end
      puts "\tRAM USAGE AFTER READ LINES: #{ram_usage}"
      items = []
      GC.start

      # with_timer do
      #   reader.close
      # end
      # puts "\tRAM USAGE AFTER CLOSE SHEET: #{ram_usage}"

      puts "\tRAM USAGE AFTER END TEST: #{ram_usage}\n\n"
    end
    final_ram_usage = ram_usage

    puts "Summary"
    puts "\tRAM USAGE BEFORE START: #{initial_ram_usage}"
    puts "\tRAM USAGE AFTER FINISH: #{final_ram_usage}"
  end

  private

  def elapsed_time(start, finish)
    "#{(finish - start) * 1000.0}ms"
  end

  def ram_usage
    # `pmap #{Process.pid} | tail -1`[10, 40].strip
    mem = GetProcessMem.new
    "#{mem.mb} MB"
  end

  def with_timer
    start = Time.now

    yield

    finish = Time.now
    puts "\tEllapsed time: #{elapsed_time(start, finish)}"
  end
end
