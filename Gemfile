source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.3'

gem 'rails', '~> 6.0.1'

gem 'devise'
gem 'pg'
gem 'puma', '~> 4.3'
gem 'sass-rails', '>= 6'
gem 'webpacker', '~> 4.0'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.7'
gem 'bootsnap', '>= 1.4.2', require: false
gem 'jquery-rails'
gem 'twitter-bootstrap-rails'
# Template generator
gem 'html2slim'
gem 'slim-rails'
# Controller helpers
gem 'decent_exposure'
# AWS API
gem 'aws-sdk-s3', require: false
# Nested forms
gem 'cocoon'
# Controller data in JS
gem 'gon'
# Authorization
gem 'cancancan'
# Auth code flow
gem 'doorkeeper'

gem 'active_model_serializers', '~> 0.10'
gem 'oj'

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  gem 'factory_bot_rails'
  gem 'rspec-rails', '~> 4.0.0.beta2'
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'shoulda-matchers'
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  gem 'webdrivers'
  gem 'rails-controller-testing'
  gem 'launchy'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
