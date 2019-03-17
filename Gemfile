# frozen_string_literal: true

source 'https://rubygems.org'
ruby '2.6.1'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

gem 'pg', '~> 0.18'
gem 'puma', '~> 3.7'
gem 'rails', '~> 5.2'
gem 'redis-rails'
gem 'turbolinks'
gem 'webpacker'

gem 'sendgrid-ruby'
gem "skylight"

gem 'devise'
gem 'omniauth'
gem 'searchkick'

# gem 'omniauth-google'
# gem 'omniauth-facebook'
# gem 'high_voltage', '~> 3.1'
gem "haml-rails", "~> 1.0"

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  # Adds support for Capybara system testing and selenium driver
  gem 'rspec-rails'
  gem 'capybara', '~> 2.13'
  gem 'selenium-webdriver'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '>= 3.3.0'
  gem 'awesome_print'
  gem 'annotate_models'
end

