#ifndef FAST_XLSX_H
#define FAST_XLSX_H 1

#include "ruby.h"

void Init_fast_xlsx(void);

void Init_fast_xlsx_reader(VALUE mainModule);

void Init_fast_xlsx_writer(VALUE mainModule);

#endif /* FAST_XLSX_H */
