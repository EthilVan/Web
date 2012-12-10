# -*- coding: utf-8 -*-
source :rubygems

# Core
gem 'rake'
gem 'sinatra'
gem 'sinatra-contrib'
gem 'activerecord'
gem 'mysql2', platforms: :ruby
gem 'activerecord-jdbcmysql-adapter', platforms: :jruby
gem 'mustache'

# Assets
gem 'rainpress'
gem 'gemoji'

# Librairies
gem 'bcrypt-ruby'
gem 'redcarpet', platforms: :ruby
gem 'jruby-pegdown', platforms: :jruby,
      git: 'git://github.com/EthilVan/jruby-pegdown.git'
gem 'nokogiri'
# gem 'will_paginate'
gem 'chunky_png'
# gem 'image_size'


gem 'thin', platforms: :ruby

# Développement
group :development do
   gem 'pry'
   gem 'watchr'
   gem 'puma', platforms: :jruby
   gem 'better_errors'
   gem 'binding_of_caller'
   gem 'rack-mini-profiler'
end

# Test
group :test do
   gem 'minitest'
   gem 'rack-test'
   gem 'factory_girl'
   gem 'database_cleaner'
end
