source 'https://rubygems.org'

ruby '1.9.3'
gem 'rails', '3.2.8'
gem 'rails-i18n'

# https://gist.github.com/741873
group :production do
  # Error logging
  gem 'airbrake'

  # Performance
  gem 'dalli'
  gem 'newrelic_rpm'
  gem 'rack-cache'
end

# Database
gem 'mongo'
gem 'bson'
gem 'bson_ext'
gem 'mongo_mapper', '0.11.2'

# Feeds
gem 'ri_cal'

# Image uploads
gem 'fog'
gem 'rmagick'
gem 'carrierwave'
gem 'mm-carrierwave'

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
gem 'dragonfly', :git => 'git://github.com/jpmckinney/dragonfly.git'
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
  gem 'turn', :require => false
end

group :development, :test do
  gem 'rspec-rails', '~> 2.6'
end

gem 'unicorn'
