# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.2'

gem 'activeadmin'
gem 'activeadmin_addons'
gem 'acts-as-taggable-on', '~> 6.0'
gem 'amazing_print'
gem 'bootsnap', '>= 1.4.2', require: false
gem 'charlock_holmes'
gem 'countries'
gem 'devise'
gem 'friendly_id', '~> 5.4.0'
gem 'graphql'
gem 'graphql-batch'
gem 'hiredis'
gem 'httparty'
gem 'pg'
gem 'puma'
gem 'rack-cors'
gem 'rails', '~> 6.0.3'
gem 'rails-observers'
gem 'recaptcha'
gem 'redis'
gem 'rollbar'
gem 'sass-rails'
gem 'sidekiq'

group :test do
  gem 'database_cleaner-active_record'
  gem 'rspec-retry'
  gem 'rspec-sidekiq'
  gem 'shoulda-matchers'
  gem 'webmock'
end

group :development, :test do
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
  gem 'letter_opener'
  gem 'listen', '>= 3.0.5', '< 3.6'
  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

gem 'marco-polo'
