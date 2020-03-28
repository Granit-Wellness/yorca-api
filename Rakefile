#!/usr/bin/env rake
# frozen_string_literal: true

task :init do
  require './config/init'
end

task :app do
  require './app'
end

# Require Rakefiles
Dir[File.dirname(__FILE__) + '/lib/tasks/*.{rb,rake}'].
  sort.
  each { |path| load path }

task default: 'ci:run'
