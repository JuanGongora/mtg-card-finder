require 'bundler'
Bundler.require

DB = {:conn => SQLite3::Database.new("db/cards.db")}

require_all 'lib'
