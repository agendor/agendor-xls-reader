# frozen_string_literal: true

coverage = ENV.fetch("COVERAGE", nil)
if !coverage.nil? && coverage == "true"
  require "simplecov"
  SimpleCov.start
end

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)

require "fast_xlsx"
require "minitest/autorun"
require "minitest/focus"
