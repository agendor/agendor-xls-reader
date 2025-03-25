# frozen_string_literal: true

require "test_helper"
require "get_process_mem"
require "fileutils"

class FastXlsxWriterTest < Minitest::Test
  def setup
    @dir = File.expand_path(File.join(File.dirname(__FILE__), "..", "tmp", "sample"))
    FileUtils.mkdir_p(@dir)
  end

  def test_initialize
    sample = File.expand_path(File.join(@dir, "exemplo.xlsx"))

    with_summary do
      with_timer do
        FastXlsx::Writer.new(sample)
      end
    end
  end

  def test_data_from_c
    puts "Create sheet from C loop"
    2.times do |main_index|
      sample = File.expand_path(File.join(@dir, "exemplo_rb-#{main_index}.xlsx"))

      puts "sheet #{main_index}"
      with_summary do
        writer = FastXlsx::Writer.new(sample)

        with_timer do
          writer.add_mock_data
        end

        with_timer do
          writer.close
        end
      end
    end
  end

  def test_data_from_rb
    puts "Create sheet from RB loop"
    2.times do |main_index|
      sample = File.expand_path(File.join(@dir, "exemplo_rb-#{main_index}.xlsx"))

      puts "sheet #{main_index}"
      with_summary do
        writer = FastXlsx::Writer.new(sample)

        with_timer do
          writer.add_column("Nome")
          writer.add_column("Idade")
          writer.add_column("País")
          writer.next_row

          100_000.times do |index|
            writer.add_cell("Test")
            writer.add_cell(index.to_s)
            writer.add_cell("Brasil")
            writer.next_row
          end
        end

        with_timer do
          writer.close
        end
      end
    end
  end

  private

  def elapsed_time(start, finish)
    "#{(finish - start) * 1000.0}ms"
  end

  def ram_usage
    mem = GetProcessMem.new
    "#{mem.mb} MB"
  end

  def with_timer
    start = Time.now

    yield

    finish = Time.now
    puts "\tEllapsed time: #{elapsed_time(start, finish)}"
  end

  def with_summary
    initial_ram_usage = ram_usage

    yield

    final_ram_usage = ram_usage

    puts "Summary"
    puts "\tRAM USAGE BEFORE START: #{initial_ram_usage}"
    puts "\tRAM USAGE AFTER FINISH: #{final_ram_usage}"
  end
end
