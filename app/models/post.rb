module Yorca
  module Models
    class Post < Sequel::Model(:posts)
      many_to_one :user

      dataset_module do
        def find_or_create!(values)
          self[values] || Drug.create!(values)
        end
      end
    end
  end
end

# Table: posts
# Columns:
#  id         | uuid                        | PRIMARY KEY DEFAULT uuid_generate_v4()
#  title      | text                        | NOT NULL
#  body       | text                        | NOT NULL
#  user_id    | uuid                        | NOT NULL
#  created_at | timestamp without time zone |
#  updated_at | timestamp without time zone |
# Indexes:
#  posts_pkey | PRIMARY KEY btree (id)
# Foreign key constraints:
#  posts_user_id_fkey | (user_id) REFERENCES users(id)
