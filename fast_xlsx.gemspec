# frozen_string_literal: true

require File.join(File.dirname(__FILE__), "lib/fast_xlsx/version")

Gem::Specification.new do |spec|
  spec.name          = "fast_xlsx"
  spec.version       = FastXlsx::VERSION
  spec.authors       = ["Franklin Ronald"]
  spec.email         = ["franklin@wiselabs.com.br"]

  spec.summary       = "Fast XLSX"
  spec.description   = "Read XSLX with low memory footprint and native performance"
  spec.homepage      = "https://www.wiselabs.com.br"
  spec.license       = "MIT"
  spec.required_ruby_version = ">= 3.0"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
          "public gem pushes."
  end

  spec.files = Dir["{lib,ext}/**/*.{rb,h,c}"]
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.extensions    = ["ext/fast_xlsx/extconf.rb"]

  spec.add_development_dependency "minitest", "~> 5"
  spec.add_development_dependency "rake-compiler", ">= 0.9", "< 2.0"
end
