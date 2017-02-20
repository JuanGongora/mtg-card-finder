require 'open-uri'
require 'nokogiri'
require 'pry'

require_relative "./scraper"
require_relative "./mtg"
require_relative "./set"

class CLI
  def self.start
    puts "Here is a list of the card sets currently available"
    puts "Please type out the number of the set you would like to see"
    Scraper.scrape_set_options
    Set.all
    # puts "What set would you like to see?"
  end

  # def self.chech_input(input)
  #   if input

end
# Scraper.scrape_cards
# MTG.all
CLI.start
