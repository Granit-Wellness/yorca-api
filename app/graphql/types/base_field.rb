# frozen_string_literal: true

module Yorca
  module Graphql
    module Types
      class BaseField < ::GraphQL::Schema::Field
        argument_class BaseArgument
      end
    end
  end
end
