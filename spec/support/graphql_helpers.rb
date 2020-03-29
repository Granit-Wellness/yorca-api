# frozen_string_literal: true

module Spec
  module Support
    module GraphqlHelpers
      def expect_error(result, field, message)
        expect(result[:node]).to eq(nil)
        expect(result[:errors]).not_to eq []

        result[:errors].find { |info| info.field == field }.tap do |error|
          expect(error).to be_present
          expect(error.messages).to include message
        end
      end

      def expect_node(result)
        expect_success(result)
        expect(result[:node]).not_to eq nil
        expect(result[:node])
      end

      def expect_success(result)
        expect(result[:errors]).to eq []
      end

      def gid(record)
        Graphql.encode_global_id(record)
      end

      def mutate_described_class(object: nil, context: { current_user: current_user }, input: {})
        described_class.new(object: object, context: context, field: nil).
          resolve(**input)
      end

      def execute_query(query, context: { current_user: current_user }, variables: {})
        result = described_class.execute(
          query,
          context: context,
          operation_name: nil,
          variables: variables,
        )

        data = result.to_h['data'].presence || raise_errors(result.to_h)
        HashWithIndifferentAccess.new(data)
      end

      def resolve_described_class(object: nil, arguments: nil, context: { current_user: current_user })
        result = GraphQL::Batch.batch do
          described_class.call(object, arguments, context)
        end

        result.respond_to?(:all) ? result.all : result
      end

      def raise_errors(result)
        messages = result['errors'].collect { |error| error['message'] }
        raise StandardError.new(messages.join(', '))
      end
    end
  end
end
