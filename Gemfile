# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.5'

gem 'activeadmin'
gem 'bootsnap', '>= 1.4.2', require: false
gem 'devise'
gem 'graphql'
gem 'graphql-batch'
gem 'pg'
gem 'puma', '~> 4.1'
gem 'rails', '~> 6.0.2'

group :test do
  gem 'database_cleaner-active_record'
  gem 'factory_bot_rails'
  gem 'faker'
end

group :development, :test do
  gem 'awesome_print'
  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'rspec-rails'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false
  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'spring-watcher-listen', '~> 2.0.0'
end
