Sequel.migration do
  change do
    create_table :users do
      column :id, :uuid, default: Sequel::LiteralString.new('uuid_generate_v4()'), null: false
      serial :iid, null: false

      text  :email, null: false
      text  :password, null: false
      text  :annonymous_name, null: false
      text  :avatar_uri

      timestamp :created_at
      timestamp :updated_at

      primary_key [:id]
      index :iid, :unique => true
      index :email
    end
  end
end
