# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.5'

gem 'activeadmin'
gem 'activeadmin_addons'
gem 'acts-as-taggable-on', '~> 6.0'
gem 'bootsnap', '>= 1.4.2', require: false
gem 'countries'
gem 'devise'
gem 'friendly_id', '~> 5.2.4'
gem 'graphql'
gem 'graphql-batch'
gem 'pg'
gem 'puma', '~> 4.1'
gem 'rails', '~> 6.0.2'

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
end

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false
  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'spring-watcher-listen', '~> 2.0.0'
end
