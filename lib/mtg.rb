class MTG
  attr_accessor :card, :sets, :market_price, :price_fluctuate#, :image
  @@all_cards = []
  ATTRIBUTES = [
      "Card:",
      "Set:",
      "Market Value:",
      "Rise/Fall amount:"
      # "Image URL:"
  ]

  #need to make instance methods from attr_accessor be associated with
  #the values I scrape from the website, all instances will be recorded
  #into class variable @@all_cards with the recorded paired method/values.
  def initialize(attributes)
    attributes.each {|key, value| self.send("#{key}=", value)}
    @@all_cards << self
  end

  def self.all
    puts "-------------------------------------------------"
    print "                                                 ".bg COLORS[7]
    #iterate through each instance of MTG made from Scraper.scrape_cards(set_url)
    #that was appended into @@all_cards during initialization
    @@all_cards.each_with_index do |card, number|
      #iterate through each instance method that was defined for
      #the instance variable of MTG from key/value pairs of Scraper.scrape_cards(set_url)
      puts ""
      puts "-------------------------------------------------"
      puts "|- #{number + 1} -|".fg COLORS[4]
      puts ""
      card.instance_variables.each_with_index do |value, index|
        #returns the value of the instance method applied to the instance
        #with an index value of the first/last, key/value pairs ordered in Scraper.scrape_cards(set_url)
        #associates a named definition of the values by titling it from constant ATTRIBUTES
        puts "#{ATTRIBUTES[index].fg COLORS[2]} #{card.instance_variable_get(value)}"
      end
      puts ""
      puts "-------------------------------------------------"
      print "                                                 ".bg COLORS[7]
    end
  end

end
