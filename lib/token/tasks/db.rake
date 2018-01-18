require 'token/db/migrator'

namespace :db do

  @base_path = File.join(Dir.pwd, 'lib', 'token')

  desc 'Migrate the database'
  task :migrate do
    Token::Db::Migrator.new(@base_path).execute
  end

end
