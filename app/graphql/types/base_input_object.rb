# frozen_string_literal: true

module Yorca
  module Graphql
    module Types
      class BaseInputObject < ::GraphQL::Schema::InputObject
        argument_class BaseArgument
      end
    end
  end
end
