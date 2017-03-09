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
    #iterate through each instance of MTG made from Scraper.scrape_cards(set_url)
    #that was appended into @@all_cards during initialization
    @@all_cards.each do |card|
      #iterate through each instance method that was defined for
      #the instance variable of MTG from key/value pairs of Scraper.scrape_cards(set_url)
      puts "-------------------------------------------------"
      card.instance_variables.each_with_index do |value, index|
        #returns the value of the instance method applied to the instance
        #with an index value of the first/last, key/value pairs ordered in Scraper.scrape_cards(set_url)
        #associates a named definition of the values by titling it from constant ATTRIBUTES
        puts "#{ATTRIBUTES[index]} #{card.instance_variable_get(value)}"
      end
      puts "-------------------------------------------------"
    end
  end

end
