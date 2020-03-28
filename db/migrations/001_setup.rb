# frozen_string_literal: true

Sequel.migration do
  change do
    run 'CREATE EXTENSION IF NOT EXISTS "uuid-ossp";'

    create_table? :migrations do
      primary_key :id
      String :name, null: false, index: true
      timestamp :ran_at
    end

    create_table? :schema_info do
      Integer :version, default: 0, null: false
    end
  end
end
