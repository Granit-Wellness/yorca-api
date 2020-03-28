  
# frozen_string_literal: true

module Yorca
  module Graphql
    module Types
      class Drug < BaseObject
        implements ::GraphQL::Relay::Node.interface

        field :id, ID, null: false
        field :name, String, null: false
      end
    end
  end
end
