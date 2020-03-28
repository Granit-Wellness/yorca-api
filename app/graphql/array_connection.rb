# frozen_string_literal: true

# For reference the parent and parent's parent class:
#
# https://github.com/rmosolgo/graphql-ruby/blob/master/lib/graphql/relay/array_connection.rb
# https://github.com/rmosolgo/graphql-ruby/blob/master/lib/graphql/relay/base_connection.rb

module Yorca
  module Graphql
    class ArrayConnection < ::GraphQL::Relay::ArrayConnection
      # Exposes this method so we can access it on the connection type for
      # pagination on the frontend.
      def total_count
        nodes.size
      end
    end
  end
end
