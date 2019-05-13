
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "topdesk_api/version"

Gem::Specification.new do |spec|
  spec.name          = "topdesk_api"
  spec.version       = TopdeskApi::VERSION
  spec.authors       = ["Juarez Lustosa"]
  spec.email         = ["juarez.lustosa@codeminer42.com, github@bioritmo.com.br"]

  spec.summary       = 'Topdesk REST API Client'
  spec.description   = 'Ruby wrapper for the REST API at https://www.topdesk.com/us. Documentation at https://developers.topdesk.com/'
  spec.license       = "MIT"

  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.17"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_runtime_dependency "faraday"
end
