module Yorca
  module Models
    class User < Sequel::Model(:users)
      def self.authenticate(email, password)
        return false if email.blank? || password.blank?

        user = self.first(email: email.downcase)

        return false unless user
        return false unless user.authenticate?(password)
        user
      end

      def authenticate?(value)
        BCrypt::Password.new(password) == value
      end
    end
  end
end

# Table: users
# Columns:
#  id         | uuid                        | PRIMARY KEY DEFAULT uuid_generate_v4()
#  iid        | integer                     | NOT NULL DEFAULT nextval('users_iid_seq'::regclass)
#  email      | text                        | NOT NULL
#  password   | text                        | NOT NULL
#  user_name  | text                        | NOT NULL
#  created_at | timestamp without time zone |
#  updated_at | timestamp without time zone |
# Indexes:
#  users_pkey        | PRIMARY KEY btree (id)
#  users_iid_index   | UNIQUE btree (iid)
#  users_email_index | btree (email)
# Referenced By:
#  posts | posts_user_id_fkey | (user_id) REFERENCES users(id)
