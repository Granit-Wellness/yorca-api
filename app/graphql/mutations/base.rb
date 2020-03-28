# frozen_string_literal: true

module Yorca
  module Graphql
    module Mutations
      class Base < ::GraphQL::Schema::RelayClassicMutation
        argument_class Types::BaseArgument

        # Generate payload types
        object_class Types::BaseObject

        # Return fields on the mutation's payload
        field_class Types::BaseField

        # Generate the `input: { ... }` object type
        input_object_class Types::BaseInputObject

        class << self
          def inherited(base)
            super

            base.instance_eval do
              graphql_name base.name.split('::').drop(3).join
              field :errors, [Types::Error], null: false
            end
          end

          def node_type(type)
            field :node, type, null: true
          end
        end

        attr_accessor :arguments

        def resolve(**arguments)
          @arguments = arguments

          perform(arguments)
        rescue Sequel::NoMatchingRow
          error_record_not_found
        rescue Sequel::ValidationFailed => error
          errors_from_record(error)
        end

        def perform(_arguments)
          raise NotImplementedError
        end

        private

        def current_account
          context[:current_account]
        end

        def current_user
          context[:current_user]
        end

        def first_node!(gid)
          first_node(gid) || raise(Sequel::NoMatchingRow)
        end

        def first_node(gid)
          Graphql.first_node(gid, context)
        end

        def error(field, message)
          {
            node: nil,
            errors: [Error.new(field, message)],
          }
        end

        def errors_from_array(errors)
          {
            node: nil,
            errors: errors.map { |field, messages| Error.new(field, messages) },
          }
        end

        def error_record_not_found
          error(:base, :record_not_found)
        end

        def errors_from_record(record)
          errors_from_array(record.errors)
        end

        def success(node = nil)
          if node.present?
            { node: node, errors: [] }
          else
            { node: nil, errors: [] }
          end
        end

        class Error
          attr_reader :field, :messages

          def initialize(field, messages)
            @field = field
            @messages = Array(messages)
          end

          def ==(other)
            field == other.field && messages == other.messages
          end
        end
      end
    end
  end
end
