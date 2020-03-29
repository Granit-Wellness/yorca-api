# frozen_string_literal: true

module Spec
  module Support
    module Helpers
      def app
        Yorca::App
      end

      def current_user(values = {})
        @current_user ||= Models::User.new(*values)
      end

      def last_response_body
        JSON.parse(last_response.body)
      end

      def post_json(path, params = {}, env = {})
        post(path, params.to_json, {
          'CONTENT_TYPE' => 'application/json',
          'ACCEPT' => 'application/json',
        }.merge(env))
      end

      def delete_json(path, params = {}, env = {})
        delete(path, params.to_json, {
          'CONTENT_TYPE' => 'application/json',
          'ACCEPT' => 'application/json',
        }.merge(env))
      end

      def fixture_mash(path)
        Mash.from_json(fixture_data(path))
      end

      def fixture_json(path)
        JSON.parse(fixture_data(path))
      end

      def fixture_data(path)
        File.open("spec/support/fixtures/#{path}", 'rb').read
      end
    end
  end
end
