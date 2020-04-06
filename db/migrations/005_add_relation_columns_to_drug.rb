# frozen_string_literal: true

Sequel.migration do
  change do
    alter_table(:drugs) do
      add_column :aliases, :jsonb, default: '[]'
      add_column :health_risks, :jsonb, default: '[]'
      add_column :effects, :jsonb, default: '[]'
    end
  end
end
