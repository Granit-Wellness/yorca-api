# frozen_string_literal: true

$LOAD_PATH << File.expand_path(__dir__)

require_relative './config/init'
require_relative './app/models'
require_relative './app/routes'

module Sample
  class App < Sinatra::Base
    configure do
      disable :method_override
      disable :show_exceptions
      disable :dump_errors
      disable :protection
      enable :raise_errors

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
    use Sample::Middleware::Cors

    use Routes::Events

    # Routes
    use Sinatra::Router do
      mount Routes::Client
    end
  end
end

include Sample # rubocop:disable Style/MixinUsage
