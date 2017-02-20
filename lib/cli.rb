require 'open-uri'
require 'nokogiri'
require 'pry'

require_relative "./scraper"
require_relative "./mtg"
require_relative "./set"


Scraper.scrape_cards
MTG.all
# Scraper.scrape_set_options
# Set.all
