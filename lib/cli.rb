require 'bundler'
Bundler.require
#this combines all of my gems into one single require

require_relative "./mtg"
require_relative "./parser"
require_relative "./color"

class CLI

  def self.start
    puts "Please select your price trend Format:"
    puts "-------------------------------------------------"
    puts "#{"|Last Update|".fg COLORS[6]}#{Parser.update_date}"
    puts "-------------------------------------------------"
    puts "#{"[1]".fg COLORS[3]} Standard: #{"rising".fg COLORS[4]} cards today"
    puts "#{"[2]".fg COLORS[3]} Modern: #{"rising".fg COLORS[4]} cards today"
    puts "#{"[3]".fg COLORS[3]} Standard: #{"crashing".fg COLORS[6]} cards today"
    puts "#{"[4]".fg COLORS[3]} Modern: #{"crashing".fg COLORS[6]} cards today"
    puts "-------------------------------------------------"
    self.check_input
    Parser.scrape_cards
    MTG.all
    # puts "What set would you like to see?"
  end

  # def self.check_input
  #   sleep(1)
  #   puts "Please type out the number of the set you would like to see from above..."
  #   input = gets.strip.to_i
  #   if Set.set_amount.include?(input)
  #     puts "You chose Set #{input}: #{Set.set_name(input)}."
  #     sleep(1)
  #     Scraper.scrape_cards(Set.set_name_url(input))
  #     MTG.all
  #   else
  #     puts "invalid option"
  #     self.check_input
  #   end
  # end

  def self.check_input
    sleep(1)
    puts "Please type out the #{"number".fg COLORS[3]} of the format you would like to see from above..."
    Parser.select_format
  end

end
