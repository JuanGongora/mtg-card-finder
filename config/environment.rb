require 'bundler'
Bundler.require
#this combines all of my gems into one single require

DB = {:conn => SQLite3::Database.new("db/cards.db")}

require_all 'lib'

#testing below
CLI.start
