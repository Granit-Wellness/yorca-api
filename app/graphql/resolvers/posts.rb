# frozen_string_literal: true

module Yorca
  module Graphql
    module Resolvers
      class Posts < Base
        def perform
          # TODO: Refactor to add pagination
          Models::Post.order_by(Sequel.desc(:created_at)).all
        end
      end
    end
  end
end
