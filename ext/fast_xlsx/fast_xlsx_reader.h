#ifndef FAST_XLSX_READER_H
#define FAST_XLSX_READER_H 1

#include "ruby.h"
#include "xlsxio_read.h"

typedef struct {
  xlsxioreader workbook;
  char *filename;
} FastXlsxReaderStruct;

void fast_xlsx_reader_free(void *ptr);

extern const rb_data_type_t fast_xlsx_reader_data_type;

VALUE fast_xlsx_reader_initialize(VALUE self, VALUE rbFileName);
VALUE fast_xlsx_reader_get_file_name(VALUE self);
VALUE fast_xlsx_reader_close(VALUE self);
VALUE fast_xlsx_reader_read_values(VALUE self, VALUE max_rows);
VALUE fast_xlsx_reader_get_headers(VALUE self);
void Init_fast_xlsx_reader(VALUE mainModule);

#endif /* FAST_XLSX_READER_H */
