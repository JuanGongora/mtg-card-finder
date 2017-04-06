class MTG
  attr_accessor :card, :sets, :market_price, :price_fluctuate#, :image
  @@all_cards = []
  @@modern_up = []
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
  end

  def self.create_modern_up(attributes)
    cards = MTG.new(attributes)
    cards.save_modern_up
    cards
  end

  def self.all
    #iterate through each instance of MTG made from Parser.scrape_cards
    #that was appended into @@all_cards during initialization
    @@modern_up.each_with_index do |card, number|
      #iterate through each instance method that was defined for
      #the instance variable of MTG from key/value pairs of Parser.scrape_cards
      puts ""
      puts "|- #{number + 1} -|".fg COLORS[4]
      puts ""
      card.instance_variables.each_with_index do |value, index|
        #returns the value of the instance method applied to the instance
        #with an index value of the first/last, key/value pairs ordered in Parser.scrape_cards
        #associates a named definition of the values by titling it from constant ATTRIBUTES
        if index < 4
          puts "#{ATTRIBUTES[index].fg COLORS[2]} #{card.instance_variable_get(value)}"
        end
      end
      puts ""
      print "                                                 ".bg COLORS[7]
    end
  end

  def self.destroy
    @@all_cards.clear
  end

  def save_modern_up
    @@modern_up << self
  end

end
