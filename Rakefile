#!/usr/bin/env rake
# frozen_string_literal: true

require "bundler/gem_tasks"
require "rake/extensiontask"
require "rake/testtask"

Rake::ExtensionTask.new("fast_xlsx") do |ext|
  ext.lib_dir = "lib/fast_xlsx"
end

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"

  _, inline_files = ARGV

  t.test_files = Array(inline_files)
  t.test_files = FileList["test/**/*_test.rb"] if inline_files.nil?
end

task build: [:clean, :compile]

task default: [:clean, :clobber, :compile, :test]
