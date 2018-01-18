require 'yaml'
require 'active_record'

module Token
  module Db
    class Migrator

      attr_reader :base_path, :db_config, :env, :migrations_paths

      def initialize(base_path, additional_paths = [])
        @base_path = base_path
        @migrations_paths = build_paths(additional_paths)
        @env = ENV['RAILS_ENV'] || ENV['RACK_ENV'] || 'development'
        @db_config = YAML.load(ERB.new(File.read(File.join(@base_path, 'config', 'database.yml'))).result)[env]
      end

      def execute
        ActiveRecord::Base.establish_connection(db_config)

        ActiveRecord::Migrator.migrate(migrations_paths)
      end

      private

      def build_paths(additional_paths)
        migrations_path = File.join('db', 'migrate')

        [ File.join(base_path, migrations_path) ] + additional_paths.map { |path| File.join(path, migrations_path) }
      end

    end
  end
end
