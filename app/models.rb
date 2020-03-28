# frozen_string_literal: true

module Yorca
  module Models
  end
end

require_relative './models/drug'
require_relative './models/post'
require_relative './models/user'

Yorca.database.loggers << Logger.new($stdout) if Yorca::Config.development?
