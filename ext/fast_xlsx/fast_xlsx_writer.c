#include "fast_xlsx_writer.h"
#include <stdlib.h>
#include "xlsxio_write.h"

VALUE rb_cFastXlsxWriter;

void fast_xlsx_writer_free(void *ptr) {
  if (!ptr) return;

  FastXlsxWriterStruct *writer = (FastXlsxWriterStruct *)ptr;
  if (writer->workbook) {
    xlsxiowrite_close(writer->workbook);
    writer->workbook = NULL;
  }

  if (writer->filename) {
    free(writer->filename);
    writer->filename = NULL;
  }

  xfree(writer);
}

const rb_data_type_t fast_xlsx_writer_data_type = {
  "FastXlsxWriter",
  {NULL, fast_xlsx_writer_free, NULL},
  NULL, NULL, RUBY_TYPED_FREE_IMMEDIATELY
};

static VALUE fast_xlsx_writer_alloc(VALUE klass) {
  FastXlsxWriterStruct *data;
  VALUE obj = TypedData_Make_Struct(klass, FastXlsxWriterStruct, &fast_xlsx_writer_data_type, data);
  data->workbook = NULL;
  data->filename = NULL;

  return obj;
}

VALUE fast_xlsx_writer_initialize (VALUE self, VALUE rbFileName){
  Check_Type(rbFileName, T_STRING);

  FastXlsxWriterStruct *data;
  TypedData_Get_Struct(self, FastXlsxWriterStruct, &fast_xlsx_writer_data_type, data);

  if (!data) {
    rb_raise(rb_eRuntimeError, "Unexpected error");
  }

  if (data->filename) {
    free(data->filename);
  }

  if (data->workbook) {
    xlsxiowrite_close(data->workbook);
  }

  const char* file_name = StringValueCStr(rbFileName);
  data->filename = strdup(file_name);
  if (!data->filename) {
    rb_raise(rb_eNoMemError, "Failed to allocate memory to filename");
  }

  data->workbook = xlsxiowrite_open(data->filename, "Sheet1");
  if (!data->workbook) {
    free(data->filename);
    data->filename = NULL;
    rb_raise(rb_eRuntimeError, "File initialization error");
  }

  return self;
}

VALUE fast_xlsx_writer_add_mock_data(VALUE self){
  FastXlsxWriterStruct *data;
  TypedData_Get_Struct(self, FastXlsxWriterStruct, &fast_xlsx_writer_data_type, data);

  if (!data || !data->workbook) {
    rb_raise(rb_eRuntimeError, "XLSX file is not open");
    return self;
  }

  xlsxiowrite_add_column(data->workbook, "Nome", 16);
  xlsxiowrite_add_column(data->workbook, "Idade", 16);
  xlsxiowrite_add_column(data->workbook, "País", 16);
  xlsxiowrite_next_row(data->workbook);

  int i;
  for (i = 0; i < 100000; i++) {
    xlsxiowrite_add_cell_string(data->workbook, "Test");
    xlsxiowrite_add_cell_int(data->workbook, i);
    xlsxiowrite_add_cell_string(data->workbook, "Brasil");
    xlsxiowrite_next_row(data->workbook);
  }

  return self;
}

VALUE fast_xlsx_writer_add_column(VALUE self, VALUE rbCellText, VALUE rbColWidth){
  FastXlsxWriterStruct *data;
  TypedData_Get_Struct(self, FastXlsxWriterStruct, &fast_xlsx_writer_data_type, data);

  if (!data || !data->workbook) {
    rb_raise(rb_eRuntimeError, "XLSX file is not open");
    return self;
  }

  Check_Type(rbCellText, T_STRING);
  Check_Type(rbColWidth, T_FIXNUM);

  const char *content = StringValueCStr(rbCellText);
  int width = NUM2INT(rbColWidth);

  xlsxiowrite_add_column(data->workbook, content, width);
  return self;
}

VALUE fast_xlsx_writer_add_cell(VALUE self, VALUE rbCellText){
  Check_Type(rbCellText, T_STRING);

  FastXlsxWriterStruct *data;
  TypedData_Get_Struct(self, FastXlsxWriterStruct, &fast_xlsx_writer_data_type, data);

  if (!data || !data->workbook) {
    rb_raise(rb_eRuntimeError, "XLSX file is not open");
    return self;
  }

  const char *content = StringValueCStr(rbCellText);
  xlsxiowrite_add_cell_string(data->workbook, content);

  return self;
}

VALUE fast_xlsx_writer_next_row(VALUE self){
  FastXlsxWriterStruct *data;
  TypedData_Get_Struct(self, FastXlsxWriterStruct, &fast_xlsx_writer_data_type, data);

  if (!data || !data->workbook) {
    rb_raise(rb_eRuntimeError, "XLSX file is not open");
    return self;
  }

  xlsxiowrite_next_row(data->workbook);

  return self;
}

VALUE fast_xlsx_writer_close(VALUE self){
  FastXlsxWriterStruct *data;
  TypedData_Get_Struct(self, FastXlsxWriterStruct, &fast_xlsx_writer_data_type, data);

  if (!data || !data->workbook) {
    rb_warn("XLSX is already closed");
    return Qtrue;
  }

  xlsxiowrite_close(data->workbook);
  data->workbook = NULL;

  return Qtrue;
}

void Init_fast_xlsx_writer(VALUE mainModule)
{
  VALUE rb_cFastXlsxWriter = rb_define_class_under(mainModule, "FastXlsxWriter", rb_cObject);
  rb_define_alloc_func(rb_cFastXlsxWriter, fast_xlsx_writer_alloc);

  rb_define_method(rb_cFastXlsxWriter, "initialize", fast_xlsx_writer_initialize, 1);
  rb_define_method(rb_cFastXlsxWriter, "next_row", fast_xlsx_writer_next_row, 0);
  rb_define_method(rb_cFastXlsxWriter, "add_cell", fast_xlsx_writer_add_cell, 1);
  rb_define_method(rb_cFastXlsxWriter, "add_column", fast_xlsx_writer_add_column, 2);
  rb_define_method(rb_cFastXlsxWriter, "close", fast_xlsx_writer_close, 0);
  rb_define_method(rb_cFastXlsxWriter, "add_mock_data", fast_xlsx_writer_add_mock_data, 0);
}
