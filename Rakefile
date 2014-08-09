require './mvw_intern.rb'

namespace :db do
  desc 'Run DB migrations'
  task :migrate do
    require 'sequel/extensions/migration'

    Sequel::Migrator.apply(MvwIntern::App.database, 'db/migrations')
  end

  desc 'Rollback migration'
  task :rollback do
    require 'sequel/extensions/migration'

    database = MvwIntern::App.database
    version  = (row = database[:schema_info].first) ? row[:version] : nil
    Sequel::Migrator.apply(database, 'db/migrations', version - 1)
  end
end

namespace :assets do
  desc 'Run `bower install`'
  task :bower do
    sh 'bower install'
  end
end
