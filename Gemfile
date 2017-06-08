source "https://rubygems.org"

branch = ENV.fetch('SOLIDUS_BRANCH', 'master')
gem "solidus", github: "solidusio/solidus", branch: branch

if branch == 'master' || branch >= "v2.0"
  gem "rails-controller-testing", group: :test
end

# hack for broken bundler dependency resolution
if branch == 'master' || branch >= "v2.3"
  gem 'rails', '~> 5.1.0'
elsif branch >= "v2.0"
  gem 'rails', '~> 5.0.0'
end

gem 'pg'
gem 'mysql2'

group :development, :test do
  gem "pry-rails"
end

gemspec
