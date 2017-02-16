# require 'open-uri'
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
end

class Scraper

  #use HTTP request to website in the 'open' method with open-uri, then
  #creates a nokogiri wrapped object inside our local variable 'doc'.
  def self.scrape_data
    doc = Nokogiri::HTML(open("http://prices.tcgplayer.com/price-guide"))
    #parses our nokogiri object for the css selector that defines our
    #preliminary category queries.
    doc.css("tbody").each do |row|
    binding.pry
    end
  end
end

Scraper.scrape_data
