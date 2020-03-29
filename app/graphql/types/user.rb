  
# frozen_string_literal: true

module Yorca
  module Graphql
    module Types
      class User < BaseObject
        implements ::GraphQL::Relay::Node.interface

        field :id, ID, null: false
        field :email, String, null: false
        field :annonymous_name, String, null: false
        field :avatar_uri, String, null: true
      end
    end
  end
end
