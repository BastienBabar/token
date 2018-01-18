$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "token"
require 'database_cleaner'
require "factory_bot"
require "minitest/autorun"

DatabaseCleaner.strategy = :truncation

class Minitest::Unit::TestCase
  include FactoryBot::Syntax::Methods
  FactoryBot.find_definitions

  @base_path = File.join(Dir.pwd, 'lib', 'token')
  @db_config = YAML.load(ERB.new(File.read(File.join(@base_path, 'config', 'database.yml'))).result)['test']
  ActiveRecord::Base.establish_connection(@db_config)
  DatabaseCleaner.clean
end

def setup_db
  # AR keeps printing annoying schema statements
  ActiveRecord::Base.logger
  ActiveRecord::Schema.define(version: 1) do
    create_table :test_models, force: true do |t|
      t.column :identity, :string
      t.timestamps null: false
    end
  end
end
