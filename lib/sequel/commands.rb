# frozen_string_literal: true

require 'logger'
require 'sequel'
require 'sequel/extensions/migration'

module Sequel
  class Commands
    DEFAULT_ANNOTATIONS = { 'app/models/*.rb' => 'Models' }.freeze

    class MultipleVersionsFound < StandardError
    end

    attr_reader :path, :namespace

    def initialize(path: 'db/migrations', logger: Logger.new($stdout), options: {})
      @path = path
      @logger = logger
      @namespace = options.delete(:namespace) || '::Application'
      @annotations = options.delete(:annotations) || {}
      @migrator_options = options
    end

    def database
      return @database if defined?(@database)

      begin
        require './config/init'
      rescue LoadError
        raise unless ENV['ALLOW_MISSING_CONFIG_INITIALIZER']
      end

      @database = Object.const_get(namespace).database
      @database.execute('SET statement_timeout TO 0;')
      @database.logger = @logger
      @database
    rescue NameError => e
      p e
      warn 'Failed to load the database:'

      if Object.const_defined?(namespace)
        warn "  - The #{namespace}#database method is missing."

        exit 3
      else
        warn "  - The #{namespace} namespace is missing."

        exit 2
      end
    rescue LoadError => e
      warn 'Failed to load the database:'
      warn '  - The ./config/init.rb file is missing.' unless File.exist?('./config/init.rb')

      exit 1
    end

    def annotate
      require 'sequel/annotate'

      annotations = DEFAULT_ANNOTATIONS.merge(@annotations)
      annotations.each do |path, modules|
        ::Sequel::Annotate.annotate(Dir[path], namespace: "#{namespace}::#{modules}")
      end
    rescue LoadError # rubocop:disable Lint/HandleExceptions
    end

    def current_version
      silence_logger do
        migrator.
          applied_migrations.
          max_by { |filename| migration_version_from_file(filename) }
      end
    end

    def down(version:)
      migrator_for_version(version, target: 0).run
    end

    def migrate
      migrator.run
    end

    def migrator(override_options = {})
      ::Sequel::TimestampMigrator.new(database, path, migrator_options.merge(override_options))
    end

    def migrator_options
      return @migrator_options if @migrator_options.key?(:allow_missing_migration_files)

      @migrator_options.merge(
        allow_missing_migration_files: ENV['RACK_ENV'] == 'development',
      )
    end

    def redo
      rollback
      migrate
    end

    def rollback(steps: 1)
      steps.times do
        migrator_for_version(current_version, target: 0).run
      end
    end

    def up(version:)
      migrator_for_version(version).run
    end

    private

    def migration_version_from_file(filename)
      filename.split('_', 2).first.to_i
    end

    def migrator_for_version(version, options = {})
      migrator(options).tap do |instance|
        instance.migration_tuples.delete_if do |(_migration, name, _directory)|
          # If it's a version number, match on that alone, otherwise match on
          # the full name.
          if version.to_s.match?(/\A\d+\z/)
            !name.start_with?("#{version}_")
          else
            name != version
          end
        end

        raise MultipleVersionsFound unless instance.migration_tuples.size == 1
      end
    end

    def silence_logger
      database.logger = nil

      result = yield

      database.logger = @logger

      result
    end
  end
end
