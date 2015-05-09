# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'unthrottle/version'

Gem::Specification.new do |spec|
  spec.name          = "Unthrottle"
  spec.version       = Unthrottle::VERSION
  spec.authors       = ["Shishir Sharma"]
  spec.email         = ["shishirsharma.in@gmail.com"]

  # if spec.respond_to?(:metadata)
  #   spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com' to prevent pushes to rubygems.org, or delete to allow pushes to any server."
  # end

  spec.summary       = %q{Centralized rate limiting for things, using Redis.}
  spec.description   = %q{Centralized rate limiting for multiple web servies, using Redis.}
  spec.homepage      = "https://github.com/shishirsharma/Unthrottle"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Dependencies
  spec.add_runtime_dependency "redis", "~> 3.2.1"
  
  spec.add_development_dependency "bundler", ">= 1.7.6"
  spec.add_development_dependency "rake", ">= 10.0"
  spec.add_development_dependency "rspec", ">= 3.2.0"
end
