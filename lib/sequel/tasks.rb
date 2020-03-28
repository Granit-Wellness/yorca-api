# frozen_string_literal: true

require 'rake'
require 'pathname'
require 'rake/tasklib'
require 'logger'
require_relative 'commands'

module Sequel
  class Tasks < Rake::TaskLib
    MODIFYING_TASKS = %w[migrate migrate:down migrate:up redo rollback].freeze

    attr_accessor :logger, :options, :path

    def initialize(namespace = :db)
      @path      = Pathname.new('db/migrations')
      @logger    = Logger.new($stdout)
      @options   = {}
      @namespace = namespace

      yield self if block_given?

      define
    end

    private

    def define
      @commands = Commands.new(path: path.to_s, logger: logger, options: options)

      define_migrate
      define_migration
      define_redo
      define_rollback
      define_version

      define_annotate
      define_dump
    end

    def define_annotate
      namespace @namespace do
        desc 'Annotate the models with the database schema'
        task annotate: :app do
          @commands.annotate
        end
      end

      enhance_modifying_tasks('annotate')
    end

    def define_dump
      namespace @namespace do
        desc 'Dump the database schema'
        task :dump do
          url = @commands.database.url

          `sequel -d #{url} > db/schema.rb`
          `pg_dump --no-owner --schema-only #{url} > db/schema.sql`
        end
      end

      enhance_modifying_tasks('dump') unless options[:disable_automatic_dump]
    end

    def define_migrate
      namespace @namespace do
        desc 'Migrate the database (options: VERSION=x)'
        task :migrate do
          if ENV['VERSION']
            @commands.up(version: ENV['VERSION'])
          else
            @commands.migrate
          end
        end

        namespace :migrate do
          desc 'Migrates the specified version down (options: VERSION=x)'
          task :down do
            @commands.down(version: ENV['VERSION'])
          end

          desc 'Migrates the specified version up (options: VERSION=x)'
          task :up do
            @commands.up(version: ENV['VERSION'])
          end
        end
      end
    end

    def define_migration
      namespace @namespace do
        desc 'Create a new migration'
        task :migration do
          # This defines no-op tasks for any command line arguments provided,
          # so `rake db:migration MigrationName` will define a `MigrationName`
          # task preventing Rake from raising an error and allowing access to
          # the argument below. Result is an emulation of the Rails migration
          # command and no weird Rake task argument syntax.
          ARGV.each do |a|
            task(a.to_sym) {}
          end

          name = ENV.fetch('NAME', ARGV[1]).tr(' ', '_').downcase
          time = Time.now.strftime('%Y%m%d%H%M%S')
          file = path.join("#{time}_#{name}.rb")

          contents = <<~MIGRATION
            # frozen_string_literal: true
            Sequel.migration do
              change do
              end
            end
          MIGRATION

          FileUtils.mkdir_p(path)
          File.write(file, contents)

          puts "  created  #{file}"
        end
      end
    end

    def define_redo
      namespace @namespace do
        desc 'Rollback and migrate the latest migration'
        task :redo do
          @commands.redo
        end
      end
    end

    def define_rollback
      namespace @namespace do
        desc 'Rolls the schema back to the previous version (options: STEPS=x)'
        task :rollback do
          steps = (ENV['STEPS'] || 1).to_i

          @commands.rollback(steps: steps)
        end
      end
    end

    def define_version
      namespace @namespace do
        desc 'Retrieves the current schema version number'
        task :version do
          version = @commands.current_version

          puts "Current version: #{version || 'none'}"
        end
      end
    end

    def enhance_modifying_tasks(task_name)
      return if ENV['RACK_ENV'] == 'production' || ENV['RACK_ENV'] == 'staging'

      MODIFYING_TASKS.each do |name|
        Rake::Task["#{@namespace}:#{name}"].enhance do
          `bin/rake #{@namespace}:#{task_name}`
        end
      end
    end
  end
end
