  
# frozen_string_literal: true

module Yorca
  module Graphql
    module Types
      class Drug < BaseObject
        implements ::GraphQL::Relay::Node.interface

        field :id, ID, null: false
        field :name, String, null: false
        field :description, String, null: true
        field :avatar_uri, String, null: true
        field :external_resource_url, String, null: true
        field :aliases, [String], null: false
        field :health_risks, [String], null: false
        field :effects, [String], null: false
      end
    end
  end
end
