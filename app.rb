# frozen_string_literal: true

$LOAD_PATH << File.expand_path(__dir__)

require_relative './config/init'
require_relative './app/models'
require_relative './app/routes'
require_relative './app/graphql'

module Yorca
  class App < Sinatra::Base
    configure do
      disable :method_override
      disable :show_exceptions
      disable :dump_errors
      disable :protection
      enable :raise_errors
      enable :sessions

      set :erb, escape_html: true

      set :sessions,
        httponly: true,
        secure: production?,
        expire_after: 5.years,
        secret: ENV['SESSION_SECRET']
    end

    register Sinatra::Instrumentation

    # Middleware
    use Rack::Deflater
    use Rack::PostBodyContentTypeParser
    use Yorca::Middleware::Cors

    use Routes::Drugs

    # Routes
    use Sinatra::Router do
      mount Routes::Graphql
    end
  end
end

include Yorca # rubocop:disable Style/MixinUsage
