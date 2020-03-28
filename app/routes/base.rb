# frozen_string_literal: true

module Yorca
  module Routes
    class Base < Sinatra::Base
      configure do
        set :root, File.expand_path('../..', __dir__)
        set :views, 'app/views'

        disable :static
        disable :protection

        disable :show_exceptions
        disable :dump_errors
        enable :raise_errors
        register Extensions::Auth

        set :erb, escape_html: true,
                  layout_options: { views: 'app/views/layouts' }
      end

      def logger
        @logger ||= Logger.new($stderr).tap do |config|
          config.level = ENV['LOG_LEVEL'] || Logger::INFO
        end
      end

      def redirect_back
        url = session[:redirect_to]

        if url && url != 'popup'
          session[:redirect_to] = nil

          redirect url
        else
          yield
        end
      end

      def request_ip
        request.ip
      end

      helpers do
        def param!(name)
          value = params[name]

          if value.blank?
            status 422
            halt json(error: {
              type: 'missing_param',
              message: format('%s cannot be blank', name),
            })
          end

          value
        end

        def json(value, options = {})
          content_type :json

          value.to_json(options)
        end

        def halt_gateway_error!(type:, message:)
          content_type :json

          error 502, {
            error: {
              type: type,
              message: message,
            },
          }.to_json
        end
      end
    end
  end
end
