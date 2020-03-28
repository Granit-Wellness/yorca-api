# frozen_string_literal: true

Sequel.migration do
  change do
    create_table(:posts) do
      column :id, :uuid, default: Sequel::LiteralString.new('uuid_generate_v4()'), null: false

      column :title, :text: null: false
      column :body, :text, null: false
      foreign_key :user_id, :users, type: 'uuid', key: [:id]
      foreign_key :drug_id, :drugs, type: 'uuid', key: [:id]

      column :created_at, DateTime
      column :updated_at, DateTime

      primary_key [:id]
    end
  end
end
