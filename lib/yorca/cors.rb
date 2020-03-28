module Yorca
  module Middleware
    class Cors
      attr_reader :app

      def initialize(app, options = {})
        @app = app
        @whitelist = options[:whitelist] || [//]
      end

      def call(env)
        return app.call(env) unless cors?(env)

        if env['REQUEST_METHOD'] == 'OPTIONS' and env['HTTP_ACCESS_CONTROL_REQUEST_METHOD']
          [200, cors_headers(env), []]

        else
          status, headers, body = app.call(env)
          [status, headers.merge(cors_headers(env)), body]
        end
      end

      protected

      def cors?(env)
        origin = env['HTTP_ORIGIN']

        origin.present? && @whitelist.any? do |rule|
          origin.match(rule).present?
        end
      end

      def cors_headers(env)
        origin = env['HTTP_ORIGIN'].to_s

        {
          'Access-Control-Allow-Origin'  => origin,
          'Access-Control-Allow-Methods' => 'GET, POST, PUT, DELETE, OPTIONS',
          'Access-Control-Allow-Headers' => 'Authorization, API-Version, Content-Type, Salesforce-App-Id'
        }
      end
    end
  end
end
