module Yorca
  module Models
    class Post < Sequel::Model(:posts)
      many_to_one :drug

      dataset_module do
        def find_or_create!(values)
          self[values] || Drug.create!(values)
        end
      end
    end
  end
end
