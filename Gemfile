# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.6'

gem 'activeadmin'
gem 'activeadmin_addons'
gem 'acts-as-taggable-on', '~> 6.0'
gem 'bootsnap', '>= 1.4.2', require: false
gem 'charlock_holmes'
gem 'countries'
gem 'devise'
gem 'friendly_id', '~> 5.2.4'
gem 'graphql'
gem 'graphql-batch'
gem 'hiredis'
gem 'pg'
gem 'puma', '~> 4.1'
gem 'rack-cors'
gem 'rails', '~> 6.0.2'
gem 'redis'
gem 'rollbar'

group :test do
  gem 'database_cleaner-active_record'
  gem 'shoulda-matchers'
end

group :development, :test do
  gem 'awesome_print'
  gem 'dotenv-rails'
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'rspec-rails'
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false
end

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'spring-watcher-listen', '~> 2.0.0'
end
