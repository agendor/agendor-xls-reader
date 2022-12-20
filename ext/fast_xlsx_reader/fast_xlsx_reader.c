#include "fast_xlsx_reader.h"
#include "xlsxio_read.h"

VALUE rb_mFastXlsxInternal;
VALUE rb_mFastXlsxInternalReader;

VALUE fast_xlsx_reader_initialize(VALUE _self, VALUE rbFileName) {
    Check_Type(rbFileName, T_STRING);

    const char* file_name = StringValueCStr(rbFileName);

    xlsxioreader xlsxioread;
    if ((xlsxioread = xlsxioread_open(file_name)) == NULL) {
      rb_raise(rb_eTypeError, "Error opening .xlsx file\n");
    } else {
      rb_iv_set(_self, "@io_handler", Data_Wrap_Struct(rb_mFastXlsxInternalReader, NULL, xlsxioread_close, xlsxioread));
      rb_iv_set(_self, "@file_name", rbFileName);
    }

    return _self;
}

VALUE fast_xlsx_reader_get_file_name(VALUE _self) {
    return rb_iv_get(_self, "@file_name");
}

VALUE fast_xlsx_reader_read(VALUE _self) {
    VALUE pointer_wrapper = rb_iv_get(_self, "@io_handler");
    xlsxioreader xlsxioread;
    Data_Get_Struct(pointer_wrapper, struct xlsxio_read_struct, xlsxioread);

    char* value;
    xlsxioreadersheet sheet;
    const char* sheetname = NULL;
    if ((sheet = xlsxioread_sheet_open(xlsxioread, sheetname, XLSXIOREAD_SKIP_EMPTY_ROWS)) != NULL) {
      while (xlsxioread_sheet_next_row(sheet)) {
        //read all columns
        int array_offset = 0;
        VALUE ruby_cells = rb_ary_new();
        while ((value = xlsxioread_sheet_next_cell(sheet)) != NULL) {
          rb_ary_store(ruby_cells, array_offset, rb_str_new(value, strlen(value)));
          xlsxioread_free(value);
          array_offset++;
        }
        rb_yield(ruby_cells);
      }
      xlsxioread_sheet_close(sheet);
    }

    return _self;
}

void Init_fast_xlsx_reader(void)
{
  rb_mFastXlsxInternal = rb_define_module("FastXlsxInternal");
  rb_mFastXlsxInternalReader = rb_define_class_under(rb_mFastXlsxInternal, "Reader", rb_cObject);
  rb_define_method(rb_mFastXlsxInternalReader, "initialize", fast_xlsx_reader_initialize, 1);
  rb_define_method(rb_mFastXlsxInternalReader, "read", fast_xlsx_reader_read, 0);
  rb_define_method(rb_mFastXlsxInternalReader, "file_name", fast_xlsx_reader_get_file_name, 0);
}
