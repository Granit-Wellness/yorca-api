# frozen_string_literal: true

module Yorca
  module Graphql
    class Schema < ::GraphQL::Schema
      mutation Mutation
      query Query

      # Opt in to the new runtime (default in future graphql-ruby versions)
      # use ::GraphQL::Execution::Interpreter

      # Add built-in connections for pagination
      # use ::GraphQL::Pagination::Connections

      # Avoid n+1s
      use ::GraphQL::Batch

      def self.id_from_object(object, _klass, _context = {})
        Graphql.encode_global_id(object)
      end

      def self.object_from_id(id, context)
        Graphql.first_node(id, context)
      end
    end
  end
end
