# frozen_string_literal: true

module Yorca
  module Graphql
    module Resolvers
      class Drugs < Base
        def perform
          Models::Drug.all
        end
      end
    end
  end
end
