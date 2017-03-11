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
    puts "Standard: rising cards today"
    Parser.scrape_cards
    MTG.all
    self.check_input
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
    input = gets.strip.to_i
  end

end
CLI.start
