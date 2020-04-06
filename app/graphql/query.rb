# frozen_string_literal: true

module Yorca
  module Graphql
    class Query < Types::BaseObject
      field :drugs, [Types::Drug], null: false, resolve: Resolvers::Drugs

      field :drug, Types::Drug, null: true, resolve: Resolvers::Drug do
        argument :id, ID, required: true
      end

      field :posts, [Types::Post], null: false, resolve: Resolvers::Posts
    end
  end
end
