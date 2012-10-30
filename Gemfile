source :rubygems

gem 'jbundler', platforms: :jruby

# Core
gem 'thor', '< 0.16.0'
gem 'sinatra', require: 'sinatra/base'
gem 'sinatra-contrib', require: false
gem 'activerecord', require: 'active_record'
gem 'mysql2', platforms: :ruby
gem 'activerecord-jdbcmysql-adapter', platforms: :jruby
gem 'mustache'
gem 'puma', require: false

# Assets
gem 'sass', require: false
gem 'rainpress', require: false

# Librairies
gem 'os', require: false
gem 'will_paginate'
gem 'gemoji', require: false
gem 'chunky_png', platforms: :ruby
gem 'image_size'
gem 'bcrypt-ruby', require: 'bcrypt'

# Développement
group :development do
   gem 'pry', require: false
   gem 'watchr', require: false
end

# Test
group :test do
   gem 'minitest', require: false
   gem 'rack-test', require: false
   gem 'factory_girl', require: false
end
