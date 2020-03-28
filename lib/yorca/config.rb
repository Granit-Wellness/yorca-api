# frozen_string_literal: true

module Yorca
  module Config
    extend self
    def environment
      ENV['RACK_ENV']
    end

    def set(key, value)
      if value.is_a?(String)
        getter = proc { value }
      else
        getter = value
      end

      define_method(key, &getter)
    end

    def configure(*envs)
      yield self if envs.empty? || envs.include?(environment.to_sym)
    end

    def development?
      environment == 'development'
    end

    def production?
      environment == 'production'
    end

    def test?
      environment == 'test'
    end

    ENV.each do |key, value|
      set(key.downcase, value)
    end

    def database_url
      ENV['DATABASE_URL'] || "postgres://localhost:5432/yorca_#{Config.environment}"
    end

    def database_url_options
      query_string = URI.parse(database_url).query
      if query_string.present?
        CGI.parse(query_string).transform_values(&:first)
      else
        {}
      end
    end

    MIN_STATEMENT_TIMEOUT = 500

    def statement_timeout
      timeout = database_url_options['statement_timeout']
      timeout ||= ENV['STATEMENT_TIMEOUT']
      timeout ||= 60_000
      timeout = timeout.to_i
      return MIN_STATEMENT_TIMEOUT if timeout < MIN_STATEMENT_TIMEOUT

      timeout
    end
  end
end
