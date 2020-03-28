  
# frozen_string_literal: true

# For reference the parent and parent's parent class:
#
# https://github.com/rmosolgo/graphql-ruby/blob/master/lib/graphql/relay/relation_connection.rb
# https://github.com/rmosolgo/graphql-ruby/blob/master/lib/graphql/relay/base_connection.rb

module Yorca
  module Graphql
    class RelationConnection < ::GraphQL::Relay::RelationConnection
      # Exposes this method so we can access it on the connection type for
      # pagination on the frontend.
      def total_count
        relation_count(nodes)
      end

      # rubocop:disable Style/IfUnlessModifier

      # Internal method
      # This is a copy of of the parent class with the exception that we call
      # `Dataset#all` at the very end vs. `Dataset#to_a`
      # This is necessary so the tactical eager loading plugin can avoid n+1s
      def paged_nodes
        return @paged_nodes if defined? @paged_nodes

        items = sliced_nodes

        if first
          if relation_limit(items).nil? || relation_limit(items) > first
            items = items.limit(first)
          end
        end

        if last
          if relation_limit(items)
            if last <= relation_limit(items)
              offset = (relation_offset(items) || 0) + (relation_limit(items) - last)
              items = items.offset(offset).limit(last)
            end
          else
            slice_count = relation_count(items)
            offset = (relation_offset(items) || 0) + slice_count - [last, slice_count].min
            items = items.offset(offset).limit(last)
          end
        end

        if max_page_size && !first && !last
          if relation_limit(items).nil? || relation_limit(items) > max_page_size
            items = items.limit(max_page_size)
          end
        end

        # Store this here so we can convert the relation to an Array
        # (this avoids an extra DB call on Sequel)
        @paged_nodes_offset = relation_offset(items)
        @paged_nodes = items.all
      end

      # rubocop:enable Style/IfUnlessModifier

      # rubocop:disable Naming/PredicateName

      # Internal method
      # Avoids expensive COUNT(*) at the cost of possibly having 1 noop request
      # at the very last page.
      def has_next_page
        if first
          paged_nodes.length >= first
        else
          false
        end
      end

      # Internal method
      # Avoids expensive COUNT(*) at the cost of possibly having 1 noop request
      # at the very first page. Not applicable when infinite scrolling.
      def has_previous_page
        if last
          paged_nodes.length >= last
        else
          false
        end
      end

      # rubocop:enable Naming/PredicateName

      private

      # Internal method
      # It's easier on the DB to query the count of an unordered set.
      def relation_count(relation)
        relation.unordered.count
      end
    end
  end
end
