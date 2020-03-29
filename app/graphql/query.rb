# frozen_string_literal: true

module Yorca
  module Graphql
    class Query < Types::BaseObject
      field :drugs, [Types::Drug], null: false, resolve: Resolvers::Drugs

      field :posts, [Types::Post], null: false, resolve: Resolvers::Posts
    end
  end
end
