# frozen_string_literal: true

source "https://rubygems.org"
ruby '2.5.0'

git_source(:github) {|repo_name| "https://github.com/#{repo_name}" }

gem 'activesupport'
gem 'dotenv', '~> 2.7.2'
gem 'foreman', require: false
gem 'nokogiri'
gem 'google-api-client', '~> 0.9', require: 'google/apis/gmail_v1'
gem 'Indirizzo'
gem 'irb', require: false
gem 'omniauth'
gem 'omniauth-google-oauth2'
gem 'rack'
gem 'rack-contrib'
gem 'rack-rewrite'
gem 'rack-tracer'
gem 'rake'
gem 'sequel', '5.8.0'
gem 'sequel-instrumentation'
gem 'sequel_pg', require: 'sequel'
gem 'sequel_polymorphic'
gem 'sequel_postgresql_triggers'
gem 'sinatra', require: 'sinatra/base'
gem 'sinatra-contrib'
gem 'sinatra-instrumentation'
gem 'sinatra-router'
gem 'sinatra-sequel'

group :development do
  gem 'backtrace_shortener'
  gem 'net-http-spy', github: 'masterkain/net-http-spy'
  gem 'sequel-annotate'
  gem 'sinatra-reloader', require: 'sinatra/reloader'
end

group :development, :test do
  gem 'faker'
  gem 'pry-byebug'
  gem 'rspec'
  gem 'stackprof'
end

group :test do
  gem 'database_cleaner'
  gem 'factory_bot'
  gem 'rack-test'
  gem 'rspec-arguments'
  gem 'sqlite3'
  gem 'timecop'
  gem 'webmock'
end
