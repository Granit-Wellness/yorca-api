  
# frozen_string_literal: true

module Yorca
  module Graphql
    module Resolvers
      autoload :Base, 'app/graphql/resolvers/base'
      autoload :Drugs, 'app/graphql/resolvers/drugs'
      autoload :Posts, 'app/graphql/resolvers/posts'
    end
  end
end
