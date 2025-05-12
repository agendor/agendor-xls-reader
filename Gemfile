# frozen_string_literal: true

source "https://rubygems.org"

git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

gemspec

group :development do
  gem "get_process_mem"
  gem "minitest", "~> 5"
  gem "minitest-focus", "~> 1.4"
  gem "rake-compiler", ">= 1.2.0"
  gem "rubocop", "~> 1.47", require: false
  gem "rubocop-minitest", "~> 0.28.0", require: false
end
