#!/usr/bin/env ruby

# Gets all registered email addresses.

$LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__) + '/..'))

require 'mvw_intern'

DB = MvwIntern::App.database

DB['SELECT email FROM users'].each do |row|
  puts row[:email]
end
