require "mkmf"
$CFLAGS += ' -DUSE_MINIZIP -Wno-suggest-attribute=format -Wno-discarded-qualifiers'
create_makefile("fast_xlsxreader/fast_xlsxreader")
