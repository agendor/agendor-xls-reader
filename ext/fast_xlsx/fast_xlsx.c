#include "ruby.h"
#include "fast_xlsx.h"
#include "fast_xlsx_writer.h"
#include "fast_xlsx_reader.h"

void Init_fast_xlsx() {
  VALUE mainModule = rb_define_module("FastXlsx");

  Init_fast_xlsx_writer(mainModule);
  Init_fast_xlsx_reader(mainModule);
}