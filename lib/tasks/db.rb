# frozen_string_literal: true

require_relative '../sequel/tasks'

Sequel::Tasks.new do |t|
  t.options[:namespace] = 'Yorca'
  t.options[:disable_automatic_dump] = true
end
