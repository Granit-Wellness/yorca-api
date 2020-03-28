# Sample model -- Does not work!

module Sample
  module Models
    class Drug < Sequel::Model(:drugs)
      dataset_module do
        def find_or_create!(values)
          self[values] || Drug.create!(values)
        end
      end
    end
  end
end
