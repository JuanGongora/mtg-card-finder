require 'open-uri'
require 'bundler'
Bundler.require
#this combines all of my gems into one single require

DB = {:conn => SQLite3::Database.new("db/cards.db")} #this gives me validation to reach the database that module Persistable interacts with

require_all 'lib'
