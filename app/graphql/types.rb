# frozen_string_literal: true

module Yorca
  module Graphql
    module Types
      autoload :BaseArgument, 'app/graphql/types/base_argument'
      autoload :BaseObject, 'app/graphql/types/base_object'
      autoload :BaseField, 'app/graphql/types/base_field'
      autoload :BaseInputObject, 'app/graphql/types/base_input_object'
      autoload :DateTime, 'app/graphql/types/date_time'
      autoload :Drug, 'app/graphql/types/drug'
      autoload :Post, 'app/graphql/types/post'
      autoload :User, 'app/graphql/types/user'
    end
  end
end
