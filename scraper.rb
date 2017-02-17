require 'open-uri'
require 'nokogiri'
require 'pry'

class MTG
  attr_accessor :card, :rarity, :market_price, :wholesale_price, :image
  @@all_cards = []

  #need to make instance methods from attr_accessor be associated with
  #the values I scrape from the website, all instances will be recorded
  #into class variable @@all_cards with the recorded paired method values.
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
      card.instance_variables.each_with_index do |value, index|
        #returns the value of the instance method applied to the instance
        #with an index value of the first/last, key/value pairs ordered in Scraper.scrape_data
        puts "#{index}: #{card.instance_variable_get(value)}"
      end
    end
  end

end

class Scraper

  #use HTTP request to website in the 'open' method with open-uri, then
  #creates a nokogiri wrapped object inside our local variable 'doc'.
  def self.scrape_data
    doc = Nokogiri::HTML(open("http://prices.tcgplayer.com/price-guide"))
    #parses our nokogiri object for the css selector that defines our
    #preliminary category queries.
    doc.css("tbody").each do |row|
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
end

Scraper.scrape_data
MTG.all
# ^^^
# returned values from MTG.all below:
# 0: Aegis Automaton
# 1: C
# 2: 0.03
# 3: 0.0
# 4: http://i.tcgplayer.com/126339_200w.jpg
