# frozen_string_literal: true

require 'sequel'
require 'sequel/plugins/serialization'

module Sample
  extend self
  def database
    @database ||= connect!
  end

  # Useful for forcing re-connect when Config.statement_timeout changes.
  # (i.e tests, migrations)
  def connect!(value = nil)
    Sequel.connect(Config.database_url, connect_sqls: connect_sqls(value)).tap do |db|
      db.extension :pg_array
      db.extension :pg_json
      db.extension :pg_enum
      db.extension :auto_literal_strings
      db.extension :null_dataset
    end
  end

  private

  def connect_sqls(value)
    connect_sqls = []
    statement_timeout = (value || Config.statement_timeout)
    connect_sqls << "SET statement_timeout TO #{statement_timeout}" if statement_timeout
  end
end

Sequel::Deprecation.output = false

# instrument needs to be called before the a database connection is opened or
# else the database extensions won't be included.
Sequel::Instrumentation.instrument

# Preload db
Sample.database

Sequel.extension :pg_array_ops
Sequel.extension :pg_json_ops
Sequel.extension :auto_literal_strings

Sequel::Model.plugin Sequel::Plugins::Batch
Sequel::Model.plugin Sequel::Plugins::ModelTracing
Sequel::Model.plugin Sequel::Plugins::PlainFullText
Sequel::Model.plugin :polymorphic
Sequel::Model.plugin :tactical_eager_loading
Sequel::Model.plugin :update_or_create
Sequel::Model.plugin :timestamps
Sequel::Model.plugin :validation_helpers

Sequel.split_symbols = true
# We're using pg_json_ops which returns hashes
Sequel::Plugins::Serialization.register_format(
  :mash,
  ->(v) { v.to_json },
  ->(v) { Clearbit::Mash.new(v.is_a?(String) ? JSON.parse(v) : v) },
)

Sequel::Plugins::Serialization.register_format(
  :json,
  ->(v) { v.to_json },
  ->(v) { v.is_a?(String) ? JSON.parse(v, symbolize_names: true) : v },
)

# Don't cast keys to symbols if we don't need to
Sequel::Plugins::Serialization.register_format(
  :raw_json,
  ->(v) { v.to_json },
  ->(v) { v.is_a?(String) ? JSON.parse(v) : v },
)
