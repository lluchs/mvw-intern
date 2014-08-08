require './mvw_intern.rb'

namespace :db do
  desc 'Run DB migrations'
  task :migrate do
    require 'sequel/extensions/migration'

    Sequel::Migrator.apply(MvwIntern::App.database, 'db/migrations')
  end
end
