# frozen_string_literal: true

module Sample
  module Models
  end
end

require_relative './models/event'

Sample.database.loggers << Logger.new($stdout) if Sample::Config.development?
