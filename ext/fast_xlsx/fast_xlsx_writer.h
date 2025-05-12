#ifndef FAST_XLSX_WRITER_H
#define FAST_XLSX_WRITER_H 1

#include "ruby.h"
#include "xlsxio_write.h"

typedef struct {
  xlsxiowriter workbook;
  char *filename;
} FastXlsxWriterStruct;

void fast_xlsx_writer_free(void *ptr);

extern const rb_data_type_t fast_xlsx_writer_data_type;

VALUE fast_xlsx_writer_initialize(VALUE self, VALUE rbFileName);
VALUE fast_xlsx_writer_add_column(VALUE self, VALUE rbCellText, VALUE rbColWidth);
VALUE fast_xlsx_writer_add_cell(VALUE self, VALUE rbCellText);
VALUE fast_xlsx_writer_next_row(VALUE self);
VALUE fast_xlsx_writer_close(VALUE self);
void Init_fast_xlsx_writer(VALUE mainModule);

#endif /* FAST_XLSX_WRITER_H */
