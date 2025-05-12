# frozen_string_literal: true

require "test_helper"

class FastXlsxReaderTest < Minitest::Test
  def test_open_file
    sample = File.join(File.dirname(__FILE__), "sample", "data_1mb.xlsx")

    reader = FastXlsx::Reader.new(sample)

    assert_equal sample, reader.file_name
  end

  def test_invalid_file
    xlsx_example = File.join(File.dirname(__FILE__), "sample", "not_found.xlsx")
    assert_raises RuntimeError do
      FastXlsx::Reader.new(xlsx_example)
    end
  end

  def test_each_row_medium_file
    sample = File.join(File.dirname(__FILE__), "sample", "empresa-30000.xlsx")

    reader = FastXlsx::Reader.new(sample)

    count = 0

    reader.each do |_row|
      count += 1
    end

    assert_equal 30_000, count
  end

  def test_each_row_medium_file_limiting_row_count
    sample = File.join(File.dirname(__FILE__), "sample", "empresa-30000.xlsx")

    reader = FastXlsx::Reader.new(sample)

    max_rows = 10
    count = 0

    reader.each(max_rows: max_rows) do |_row|
      count += 1
    end

    assert_equal 10, count
  end

  def test_each_row_large_file
    sample = File.join(File.dirname(__FILE__), "sample", "empresa-235000.xlsx")

    reader = FastXlsx::Reader.new(sample)

    count = 0

    reader.each do |_row|
      count += 1
    end

    assert_equal 235_000, count
  end

  def test_each_row_large_file_limiting_row_count
    sample = File.join(File.dirname(__FILE__), "sample", "empresa-235000.xlsx")

    reader = FastXlsx::Reader.new(sample)

    max_rows = 10
    count = 0

    reader.each(max_rows: max_rows) do |_row|
      count += 1
    end

    assert_equal 10, count
  end

  def test_headers
    sample = File.join(File.dirname(__FILE__), "sample", "empresa-235000.xlsx")

    reader = FastXlsx::Reader.new(sample)

    expected_headers = ["Nome ", "CNPJ", "Razão Social", "Categoria", "Evento", "Usuário responsável", "Setor", "Descrição", "E-mail", "WhatsApp", "Telefone", "Celular", "Fax", "Ramal", "Website", "CEP", "País", "Estado", "Cidade", "Bairro", "Rua", "Número", "Complemento", "Produto", "Facebook", "Twitter", "LinkedIn", "Skype", "Instagram", "Ranking", ""]
    assert_equal expected_headers, reader.headers
  end
end
