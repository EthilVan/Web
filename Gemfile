source :rubygems

# Core
gem 'thor'
gem 'sinatra'
gem 'activerecord', require: 'active_record'
gem 'mysql2'
gem 'mustache'

# Assets
gem 'sass', require: false
gem 'rainpress', require: false
gem 'execjs', require: false

# Librairies
gem 'sinatra-flash', require: 'sinatra/flash'
gem 'will_paginate'
gem 'redcarpet'
gem 'gemoji'
gem 'chunky_png'
gem 'image_size'
gem 'bcrypt-ruby', require: 'bcrypt'

# Développement
group :development do
   gem 'thin'
   gem 'shotgun'
end

# Production
group :production do
   gem 'puma'
end

# Test
group :test do
   gem 'minitest', require: 'minitest/autorun'
   gem 'rack-test', require: 'rack/test'
   gem 'factory_girl'
end
