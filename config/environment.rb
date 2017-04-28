require 'open-uri'
require 'sqlite3'
require "tco"
require "mechanize"
require "nokogiri"
require 'fileutils' # for creating the directory

DIR = "db"
FileUtils.makedirs(DIR)

DB = {:conn => SQLite3::Database.new("db/cards.db")} #this gives me validation to reach the database that module Persistable interacts with

require_relative '../lib/mtg_card_finder/cli'
require_relative '../lib/mtg_card_finder/color'
require_relative '../lib/mtg_card_finder/mtg'
require_relative '../lib/mtg_card_finder/parser'
require_relative '../lib/mtg_card_finder/concerns/persistable'
require_relative '../lib/mtg_card_finder/tables/modern_fall'
require_relative '../lib/mtg_card_finder/tables/modern_rise'
require_relative '../lib/mtg_card_finder/tables/standard_fall'
require_relative '../lib/mtg_card_finder/tables/standard_rise'
