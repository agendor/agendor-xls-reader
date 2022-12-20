require "mkmf"
$CFLAGS  += ' -DUSE_MINIZIP -Wno-suggest-attribute=format -Wno-discarded-qualifiers'
$LDFLAGS += ' -lminizip -lexpat'
create_makefile("fast_xlsx_reader/fast_xlsx_reader")
