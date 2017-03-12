require 'bundler'
Bundler.require

require_relative "./mtg"
require_relative "./parser"

class CLI

  def self.start
    puts "Please select your price trend Format:"
    puts "-------------------------------------------------"
    puts "|Last Update|#{Parser.update_date}"
    puts "-------------------------------------------------"
    puts "[1] Standard: rising cards today"
    puts "[2] Modern: rising cards today"
    puts "[3] Standard: crashing cards today"
    puts "[4] Modern: crashing cards today"
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
    puts "Please type out the number of the format you would like to see from above..."
    Parser.select_format
  end

end
CLI.start
