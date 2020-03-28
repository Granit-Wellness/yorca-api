# frozen_string_literal: true

Sequel.migration do
  change do
    create_table(:drugs) do
      column :id, :uuid, default: Sequel::LiteralString.new('uuid_generate_v4()'), null: false

      column :name, :text, null: false, unique: true
      column :avatar_uri, :text
      column :description, :text
      column :external_resource_url, :text

      column :created_at, DateTime
      column :updated_at, DateTime

      primary_key [:id]
    end
  end
end
