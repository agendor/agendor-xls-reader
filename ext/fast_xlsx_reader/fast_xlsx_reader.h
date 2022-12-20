#ifndef FAST_XLSX_READER_H
#define FAST_XLSX_READER_H 1

#include "ruby.h"

VALUE fast_xlsx_reader_initialize(VALUE _self, VALUE rbFileName);

VALUE fast_xlsx_reader_get_file_name(VALUE _self);

VALUE fast_xlsx_reader_read(VALUE _self);

void Init_fast_xlsx_reader(void);

#endif /* FAST_XLSX_READER_H */
