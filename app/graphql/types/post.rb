  
# frozen_string_literal: true

module Yorca
  module Graphql
    module Types
      class Post < BaseObject
        implements ::GraphQL::Relay::Node.interface

        field :id, ID, null: false
        field :title, String, null: false
        field :body, String, null: true
        field :user, Types::User, null: false
      end
    end
  end
end
