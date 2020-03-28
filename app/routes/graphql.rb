# frozen_string_literal: true

module Yorca
  module Routes
    class Graphql < Base
      post '/graphql' do
        result = Yorca::Graphql::Schema.execute(
          query,
          context: context,
          operation_name: operation_name,
          variables: variables,
        )

        json result
      rescue StandardError => error
        raise unless Config.development?

        handle_error(error)
      end

      private

      def query
        params[:query]
      end

      def context
        {
          current_user: current_user,
        }
      end

      def operation_name
        params[:operationName]
      end

      def variables
        ensure_hash(params[:variables])
      end

      def ensure_hash(ambiguous_param)
        case ambiguous_param
        when String
          if ambiguous_param.present?
            ensure_hash(JSON.parse(ambiguous_param))
          else
            {}
          end
        when Hash
          ambiguous_param
        when nil
          {}
        else
          raise ArgumentError.new("Unexpected parameter: #{ambiguous_param}")
        end
      end

      def handle_error(error)
        logger.error error.message
        logger.error error.backtrace.join("\n")

        error 500, {
          data: {},
          error: {
            message: error.message,
            backtrace: error.backtrace,
          },
        }.to_json
      end
    end
  end
end
