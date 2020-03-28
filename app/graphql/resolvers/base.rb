# frozen_string_literal: true

module Yorca
  module Graphql
    module Resolvers
      class Base
        attr_reader :object, :arguments, :context

        def self.call(*args)
          new(*args).perform
        end

        def initialize(object, arguments, context)
          @object = object
          @arguments = format_hash(arguments)
          @context = context
        end

        def perform
          raise NotImplementedError
        end

        private

        def current_user
          context[:current_user]
        end

        def format_hash(object)
          HashWithIndifferentAccess.new(
            object.to_h.deep_transform_keys { |key| key.to_s.underscore },
          )
        end
      end
    end
  end
end
