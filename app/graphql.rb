# frozen_string_literal: true

module Yorca
  module Graphql
    autoload :ArrayConnection, 'app/graphql/array_connection'
    autoload :Loaders, 'app/graphql/loaders'
    autoload :Mutation, 'app/graphql/mutation'
    autoload :Mutations, 'app/graphql/mutations'
    autoload :Query, 'app/graphql/query'
    autoload :RelationConnection, 'app/graphql/relation_connection'
    autoload :Resolvers, 'app/graphql/resolvers'
    autoload :Schema, 'app/graphql/schema'
    autoload :Types, 'app/graphql/types'

    def self.decode(gid)
      return if gid.blank?

      klass_name, id = ::GraphQL::Schema::UniqueWithinType.decode(gid)
      klass = Object.const_get("Models::#{klass_name}")

      [klass, id]
    end

    def self.decode_id(gid)
      _klass, id = decode(gid)
      id
    end

    def self.encode_global_id(record)
      return if record.blank?

      ::GraphQL::Schema::UniqueWithinType.encode(record.class.name, record.id)
    end

    def self.first_node(gid, context)
      klass, id = decode(gid)
      return if klass.blank?

      where = {
        account_id: context[:current_account].id,
        archived_at: nil,
      }

      # Remove above default scopes if they are not supported
      where.select! { |key, _| klass.columns.include?(key) }

      Queries::Node.first(
        klass,
        id,
        where: where,
      )
    end
  end
end

GraphQL::Relay::BaseConnection.register_connection_implementation(
  Array,
  Yorca::Graphql::ArrayConnection,
)

GraphQL::Relay::BaseConnection.register_connection_implementation(
  Sequel::Dataset,
  Yorca::Graphql::RelationConnection,
)
