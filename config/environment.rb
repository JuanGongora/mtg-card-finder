require 'open-uri'
require 'sqlite3'
require "tco"
require "mechanize"
require "nokogiri"
require "require_all"

DB = {:conn => SQLite3::Database.new("db/cards.db")} #this gives me validation to reach the database that module Persistable interacts with

require_all 'lib/mtg_card_finder' #this allows me to simultaneously require everything in lib/mtg_card_finder
