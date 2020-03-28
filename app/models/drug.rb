module Yorca
  module Models
    class Drug < Sequel::Model(:drugs)
      one_to_many :posts
  
      dataset_module do
        def find_or_create!(values)
          self[values] || Drug.create!(values)
        end
      end
    end
  end
end

# Table: drugs
# Columns:
#  id         | uuid                        | PRIMARY KEY DEFAULT uuid_generate_v4()
#  name       | text                        | NOT NULL
#  created_at | timestamp without time zone |
#  updated_at | timestamp without time zone |
# Indexes:
#  drugs_pkey | PRIMARY KEY btree (id)
