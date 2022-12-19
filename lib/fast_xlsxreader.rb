require "fast_xlsxreader/version"
require "fast_xlsxreader/fast_xlsxreader"

module FastXlsxreader

  xlsx = FastXlsxReader(file_path)
  xlsx.each_row do |row|
    columns_count = row.columns_count
    col_1_value = row.value[0]
    col_2_value = row.value[1]
    col_3_value = row.value[2]
    col_4_value = row.value[3]
  end

end
