# frozen_string_literal: true

require 'rubygems'
require 'bundler'

ENV['RACK_ENV'] ||= 'development'

# Setup load paths
Bundler.require(:default, ENV['RACK_ENV'].to_sym)

require 'dotenv'
Dotenv.load(
  File.expand_path("../../.env.#{ENV['RACK_ENV']}", __FILE__),
)

require 'active_support'
require 'active_support/core_ext'
require 'active_support/json'
require 'csv'

# Require libraries
Dir[File.expand_path('../lib/**/*.rb', __dir__)].
  reject { |p| p =~ %r{/tasks/} }.
  sort.
  each { |path| require path }

# Require initializers
Dir[File.expand_path('initializers/*.rb', __dir__)].
  sort.
  each { |path| require path }
