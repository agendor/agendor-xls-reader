
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "fast_xlsx_reader/version"

Gem::Specification.new do |spec|
  spec.name          = "fast_xlsx_reader"
  spec.version       = FastXlsxReader::VERSION
  spec.authors       = ["Franklin Ronald"]
  spec.email         = ["franklin@wiselabs.com.br"]

  spec.summary       = %q{Fast XLSX reader}
  spec.description   = %q{Read XSLX with low memory footprint and native performance}
  spec.homepage      = "https://www.wiselabs.com.br"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.extensions    = ["ext/fast_xlsx_reader/extconf.rb"]

  spec.add_development_dependency "bundler", "~> 2.3.26"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rake-compiler"
  spec.add_development_dependency "minitest", "~> 5.16"
end
