#include "fast_xlsxreader.h"

VALUE rb_mFastXlsxreader;

void
Init_fast_xlsxreader(void)
{
  rb_mFastXlsxreader = rb_define_module("FastXlsxreader");
}
