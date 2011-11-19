source 'http://rubygems.org'

gem 'rails', '3.1.0'

# Bundle edge Rails instead:
# gem 'rails',     :git => 'git://github.com/rails/rails.git'

gem 'mongo', '= 1.4.0'
gem 'bson', '= 1.4.0'
gem 'bson_ext', '= 1.4.0'
gem 'mongo_mapper'

gem 'twitter'
gem 'twitter-text'

# Rake
gem 'andand'
gem 'faraday'
gem 'home_run' # faster date parsing
gem 'feedzirra'
gem 'nokogiri'
gem 'rest-client'
gem 'dragonfly', :git => 'git://github.com/jpmckinney/dragonfly.git'
gem 'unbreakable', '~> 0.0.4'
gem 'unicode_utils'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails', "  ~> 3.1.0"
  gem 'coffee-rails', "~> 3.1.0"
  gem 'uglifier'
end

gem 'haml-rails'
gem 'jquery-rails'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'

group :test do
  # Pretty printed test output
  gem 'turn', :require => false
end

group :test, :development do
  gem 'rspec-rails', '~> 2.6.1'
end

# https://gist.github.com/741873
group :production do
  gem 'pg'
  gem 'dalli'
  gem 'rack-cache'
end
