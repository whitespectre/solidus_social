require 'capybara/rspec'
require 'capybara/rails'
require 'capybara/poltergeist'
require 'capybara-screenshot/rspec'
require 'selenium-webdriver'

RSpec.configure do |config|
  config.include Rack::Test::Methods, type: :requests

  Capybara.javascript_driver = :selenium_chrome_headless
end
