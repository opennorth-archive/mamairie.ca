source 'https://rubygems.org'

ruby '1.9.3'
gem 'rails', '3.2.13'
gem 'rails-i18n'

# https://gist.github.com/741873
group :production do
  # Error logging
  gem 'airbrake'

  # Performance
  gem 'memcachier'
  gem 'dalli'
  gem 'newrelic_rpm', '3.5.3.25'
  gem 'rack-cache'
end

gem 'popolo'
gem 'carrierwave-mongoid', path: '/Users/james/.rvm/gems/ruby-1.9.3-p194/bundler/gems/carrierwave-mongoid-28a9b718d42b'

# Database
gem 'mongoid', '~> 3.0.6'
gem 'mongoid-tree', require: 'mongoid/tree'

# Feeds
gem 'ri_cal'

# Views
gem 'haml-rails'
gem 'unicode_utils'

# Scraper
gem 'andand'
gem 'faraday'
gem 'home_run' # faster date parsing
gem 'feedzirra'
gem 'nokogiri'
gem 'rest-client'
gem 'dragonfly', git: 'git://github.com/jpmckinney/dragonfly.git'
gem 'unbreakable', '~> 0.0.6'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'

group :test do
  # Pretty printed test output
  gem 'turn', require: false
end

group :development, :test do
  gem 'rspec-rails', '~> 2.11'
  gem 'shoulda-matchers', '~> 1.0'
end

gem 'unicorn'
