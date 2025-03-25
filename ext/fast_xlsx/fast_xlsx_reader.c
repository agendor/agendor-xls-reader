#include "fast_xlsx_reader.h"
#include "xlsxio_read.h"

VALUE rb_cFastXlsxReader;

void fast_xlsx_reader_free(void *ptr)
{
  if (!ptr) return;

  FastXlsxReaderStruct *reader = (FastXlsxReaderStruct *)ptr;
  if (reader->workbook) {
    xlsxioread_close(reader->workbook);
    reader->workbook = NULL;
  }

  if (reader->filename) {
    free(reader->filename);
    reader->filename = NULL;
  }

  xfree(reader);
}

const rb_data_type_t fast_xlsx_reader_data_type = {
  "FastXlsxReader",
  {NULL, fast_xlsx_reader_free, NULL},
  NULL, NULL, RUBY_TYPED_FREE_IMMEDIATELY
};

static VALUE fast_xlsx_reader_alloc(VALUE klass)
{
  FastXlsxReaderStruct *data;
  VALUE obj = TypedData_Make_Struct(klass, FastXlsxReaderStruct, &fast_xlsx_reader_data_type, data);
  data->workbook = NULL;
  data->filename = NULL;

  return obj;
}

VALUE fast_xlsx_reader_initialize(VALUE self, VALUE rbFileName)
{
  Check_Type(rbFileName, T_STRING);

  FastXlsxReaderStruct *data;
  TypedData_Get_Struct(self, FastXlsxReaderStruct, &fast_xlsx_reader_data_type, data);

  if (!data) {
    rb_raise(rb_eRuntimeError, "Unexpected error");
  }

  if (data->filename) {
    free(data->filename);
  }

  if (data->workbook) {
    xlsxioread_close(data->workbook);
  }

  const char* file_name = StringValueCStr(rbFileName);
  data->filename = strdup(file_name);
  if (!data->filename) {
    rb_raise(rb_eNoMemError, "Failed to allocate memory to filename");
  }

  data->workbook = xlsxioread_open(data->filename);
  if (!data->workbook) {
    free(data->filename);
    data->filename = NULL;
    rb_raise(rb_eRuntimeError, "XLSX file is not open");
  }

  return self;
}

VALUE fast_xlsx_reader_get_file_name(VALUE self)
{
  FastXlsxReaderStruct *data;
  TypedData_Get_Struct(self, FastXlsxReaderStruct, &fast_xlsx_reader_data_type, data);

  return rb_str_new_cstr(data->filename);
}

VALUE fast_xlsx_reader_get_headers(VALUE self)
{
  FastXlsxReaderStruct *data;
  TypedData_Get_Struct(self, FastXlsxReaderStruct, &fast_xlsx_reader_data_type, data);

  if (!data || !data->workbook) {
    rb_raise(rb_eRuntimeError, "XLSX file is not open");
    return self;
  }

  const char* sheetname = NULL;
  xlsxioreadersheet sheet = xlsxioread_sheet_open(data->workbook, sheetname, XLSXIOREAD_SKIP_EMPTY_ROWS);

  if (!sheet) {
    rb_raise(rb_eRuntimeError, "Failed to open sheet");
    return self;
  }

  xlsxioread_sheet_next_row(sheet);

  char* value;
  int array_offset = 0;
  VALUE ruby_cells = rb_ary_new();

  while ((value = xlsxioread_sheet_next_cell(sheet)) != NULL) {
    rb_ary_store(ruby_cells, array_offset, rb_str_new(value, strlen(value)));
    xlsxioread_free(value);
    array_offset++;
  }

  xlsxioread_sheet_close(sheet);

  return ruby_cells;
}

VALUE fast_xlsx_reader_read_values(VALUE self, VALUE rbMaxRows)
{
  FastXlsxReaderStruct *data;
  TypedData_Get_Struct(self, FastXlsxReaderStruct, &fast_xlsx_reader_data_type, data);

  if (!data || !data->workbook) {
    rb_raise(rb_eRuntimeError, "XLSX file is not open");
    return self;
  }

  const char* sheetname = NULL;
  int current_row_index = 0;
  int max_rows = -1;
  if(FIXNUM_P(rbMaxRows)){
    max_rows = NUM2INT(rbMaxRows);
  }
  xlsxioreadersheet sheet = xlsxioread_sheet_open(data->workbook, sheetname, XLSXIOREAD_SKIP_EMPTY_ROWS);

  if (!sheet) {
    rb_raise(rb_eRuntimeError, "Failed to open sheet");
    return self;
  }

  // Skipping headers
  xlsxioread_sheet_next_row(sheet);

  char* value;
  while (xlsxioread_sheet_next_row(sheet)) {
    if (max_rows >= 0 && current_row_index >= max_rows) break;

    //read all columns
    int array_offset = 0;
    VALUE ruby_cells = rb_ary_new();
    while ((value = xlsxioread_sheet_next_cell(sheet)) != NULL) {
      rb_ary_store(ruby_cells, array_offset, rb_str_new(value, strlen(value)));
      xlsxioread_free(value);
      array_offset++;
    }

    rb_yield(ruby_cells);
    current_row_index++;
  }
  xlsxioread_sheet_close(sheet);

  return self;
}

VALUE fast_xlsx_reader_close(VALUE self)
{
  FastXlsxReaderStruct *data;
  TypedData_Get_Struct(self, FastXlsxReaderStruct, &fast_xlsx_reader_data_type, data);

  if (!data || !data->workbook) {
    rb_warn("XLSX is already closed");
    return Qtrue;
  }

  xlsxioread_close(data->workbook);
  data->workbook = NULL;

  return self;
}

void Init_fast_xlsx_reader(VALUE mainModule)
{
  rb_cFastXlsxReader = rb_define_class_under(mainModule, "FastXlsxReader", rb_cObject);
  rb_define_alloc_func(rb_cFastXlsxReader, fast_xlsx_reader_alloc);

  rb_define_method(rb_cFastXlsxReader, "initialize", fast_xlsx_reader_initialize, 1);
  rb_define_method(rb_cFastXlsxReader, "read_values", fast_xlsx_reader_read_values, 1);
  rb_define_method(rb_cFastXlsxReader, "get_headers", fast_xlsx_reader_get_headers, 0);
  rb_define_method(rb_cFastXlsxReader, "close", fast_xlsx_reader_close, 0);
  rb_define_method(rb_cFastXlsxReader, "file_name", fast_xlsx_reader_get_file_name, 0);
}
