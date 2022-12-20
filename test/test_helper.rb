coverage = ENV["COVERAGE"]
if !coverage.nil? && coverage == "true"
  require 'simplecov'
  SimpleCov.start
end
$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "fast_xlsx_reader"
require "minitest/autorun"
