require 'open-uri'
require 'nokogiri'
require 'pry'

class MTG
  attr_accessor :card, :rarity, :market_price, :wholesale_price, :image
  @@all_cards = []
  ATTRIBUTES = [
      "Card:",
      "Rarity:",
      "Market Value:",
      "Wholesale Value:",
      "Image URL:"
  ]

  #need to make instance methods from attr_accessor be associated with
  #the values I scrape from the website, all instances will be recorded
  #into class variable @@all_cards with the recorded paired method/values.
  def initialize(attributes)
    attributes.each {|key, value| self.send("#{key}=", value)}
    @@all_cards << self
  end

  def self.all
    #iterate through each instance of MTG made from Scraper.scrape_data
    #that was appended into @@all_cards during initialization
    @@all_cards.each do |card|
      #iterate through each instance method that was defined for
      #the instance variable of MTG from key/value pairs of Scraper.scrape_data
      puts "-------------------------------------------------"
      card.instance_variables.each_with_index do |value, index|
        #returns the value of the instance method applied to the instance
        #with an index value of the first/last, key/value pairs ordered in Scraper.scrape_data
        #associates a named definition of the values by titling it from constant ATTRIBUTES
        puts "#{ATTRIBUTES[index]} #{card.instance_variable_get(value)}"
      end
      puts "-------------------------------------------------"
    end
  end

end

#each card comes from a 'card set', and there are various sets that span years of production
#since I want to have a hierarchy that allows searching of cards per set I'm making
#a similar functionality to that of class MTG with this new class 'Set'
class Set
  attr_accessor :set, :set_url
  @@all_sets = []

  #same methodology of initialization as class MTG
  def initialize(attributes)
    attributes.each {|key, value| self.send("#{key}=", value)}
    @@all_sets << self
  end

  def self.set_amount
    p @@all_sets
  end

  #I am iterating through the stored sets of @@all_sets to return
  #the first value which is the name of the set
  def self.all
    @@all_sets.each do |set|
      set.instance_variables.each_with_index do |value, index|
        #I only want to return the first value as the viewable option
        #the second value is the url for loading the set, which
        #I will later use to load the preconfigured webpage for card parsing
        if index < 1
          puts "Set: #{set.instance_variable_get(value)}"
        end
      end
    end
  end

end


class Scraper
  @@overall_set_options = nil
  @@overall_card_rows = nil
  @@iterator = nil
  # @@set_amount = 0


  #same idea here as self.scrape_cards, only I'm parsing for sets this time
  def self.scrape_set_options
    doc = Nokogiri::HTML(open("http://prices.tcgplayer.com/price-guide/magic"))
    #call Scraper.set_counter to get the total amount of sets first
    self.set_counter
    #class var below is converted to numerical array depicting the amount of sets
    @@iterator = (0..@@overall_set_options).to_a
    #I will need to parse through the index numbers of the css selectors to collect all of the sets
    #This attempt below will be to depict the number of times I want a new instance of Set to be made
    #I just need to figure out a way to make "[0].text" and "[0].attribute" increase their index
    #in proportion to @@iterator's count
    @@iterator.each do |count|
      doc.css("#set").each_with_index do |option, index|
        # if index < number
          option = Set.new({
                               set: option.css("option")[0].text.split.join(" "),
                               set_url: "http://prices.tcgplayer.com/price-guide/magic/#{option.css("option")[0].attribute("value").value}"
                           })
        # end
      end
    end
  end

  #use HTTP request to website in the 'open' method with open-uri, then
  #creates a nokogiri wrapped object inside our local variable 'doc'.
  def self.scrape_cards
    doc = Nokogiri::HTML(open("http://prices.tcgplayer.com/price-guide/magic"))
    #parses our nokogiri object for the css selector that defines our
    #preliminary category queries.
    doc.css("tbody tr").each do |row|
      #parsing is now initialized into MTG class, with key/value pairs for its scraped attributes
      row = MTG.new({
                card: row.css(".productDetail a")[0].text,
                rarity: row.css(".rarity div")[0].text.split[0],
                market_price: row.css(".marketPrice")[0].text.split[0].gsub!("$", "").to_f,
                wholesale_price: row.css(".buylistMarketPrice")[0].text.split[0].gsub!("$", "").to_f,
                image: Nokogiri::HTML(open(row.css(".shop button").attribute("onclick").value.split(" ")[2].gsub!(/('|;)/, ""))).css(".detailImage img").attribute("src").value
                # ^^ had to go another level deep to access a better quality image from its full product listing
                })
    end
  end

  #same concept as Scraper.card_counter
  def self.set_counter
    options = Nokogiri::HTML(open("http://prices.tcgplayer.com/price-guide/magic")).css("#set option")[0..-1]
    @@overall_set_options = "#{options.length}".to_i
    puts "#{@@overall_set_options} sets"
  end

  def self.card_counter
    #shows how many rows there are in total for the page, may come in handy later
    rows = Nokogiri::HTML(open("http://prices.tcgplayer.com/price-guide/magic")).css("tbody tr")[0..-1]
    @@overall_card_rows = "#{rows.length}".to_i
    puts "#{@@overall_card_rows} cards"
  end

end

# Scraper.scrape_cards
# MTG.all
Scraper.scrape_set_options
Set.all
Set.set_amount # => atleast it does seem to be returning 193 new instances, just not with the right values...
# Scraper.set_counter # => returns 193 sets in total
# Scraper.counter # => returns 198 rows for the 'set' Aether Revolt
