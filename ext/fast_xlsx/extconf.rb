# frozen_string_literal: true

require "mkmf"

extension_name = "fast_xlsx"
dir_config(extension_name)

$CFLAGS  += " -DUSE_MINIZIP -Wno-suggest-attribute=format -Wno-discarded-qualifiers"
$LDFLAGS += " -lminizip -lexpat"

create_makefile(File.join(extension_name, extension_name))

`make clean`
