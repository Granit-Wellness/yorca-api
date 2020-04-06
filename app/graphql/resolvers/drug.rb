# frozen_string_literal: true

module Yorca
  module Graphql
    module Resolvers
      class Drug < Base
        def perform
          Models::Drug.first(id: arguments[:id])
        end
      end
    end
  end
end
