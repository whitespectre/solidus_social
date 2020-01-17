# frozen_string_literal: true

$:.push File.expand_path('lib', __dir__)
require 'solidus_social/version'

Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'solidus_social'
  s.version     = SolidusSocial::VERSION
  s.summary     = 'Adds social network login services (OAuth) to Spree'
  s.description = s.summary

  s.author   = 'John Dyer'
  s.email    = 'jdyer@spreecommerce.com'
  s.homepage = 'http://www.spreecommerce.com'
  s.license  = 'BSD-3'

  if s.respond_to?(:metadata)
    s.metadata["homepage_uri"] = s.homepage if s.homepage
    s.metadata["source_code_uri"] = s.homepage if s.homepage
  end

  s.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  s.test_files = Dir['spec/**/*']
  s.bindir = "exe"
  s.executables = s.files.grep(%r{^exe/}) { |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency 'deface'
  s.add_runtime_dependency 'oa-core'
  s.add_runtime_dependency 'omniauth'
  s.add_runtime_dependency 'omniauth-amazon'
  s.add_runtime_dependency 'omniauth-facebook'
  s.add_runtime_dependency 'omniauth-github'
  s.add_runtime_dependency 'omniauth-google-oauth2'
  s.add_runtime_dependency 'omniauth-twitter'
  s.add_runtime_dependency 'solidus_auth_devise'
  s.add_runtime_dependency 'solidus_core', ['>= 1.0', '< 3']
  s.add_runtime_dependency 'solidus_support', '~> 0.4.0'

  s.add_development_dependency 'solidus_dev_support'
end
