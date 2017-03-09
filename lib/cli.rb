require 'open-uri'
require 'nokogiri'
require 'pry'

require_relative "./scraper"
require_relative "./mtg"
require_relative "./set"

class CLI

  def self.start
    puts "Here is a list of the card sets currently available"
    Scraper.scrape_set_options
    Set.all
    self.check_input
    # puts "What set would you like to see?"
  end

  def self.check_input
    sleep(1)
    puts "Please type out the number of the set you would like to see from above..."
    input = gets.strip.to_i
    if Set.set_amount.include?(input)
      puts "You chose Set #{input}: #{Set.set_name(input)}."
      sleep(1)
      Scraper.scrape_cards(Set.set_name_url(input))
      MTG.all
    else
      puts "invalid option"
      self.check_input
    end
  end

end
