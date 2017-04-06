class MTG
  attr_accessor :card, :sets, :market_price, :price_fluctuate#, :image
  @@modern_up = []
  @@modern_down = []
  @@standard_up = []
  @@standard_down = []

  ATTRIBUTES = [
      "Card:",
      "Set:",
      "Market Value:",
      "Rise/Fall amount:"
  # "Image URL:"
  ]

  #new instance will be created with already assigned values to MTG attrs
  def initialize(attributes)
    attributes.each {|key, value| self.send("#{key}=", value)}
  end

  def self.create_modern_up(attributes)
    #allows cards instance to auto return thanks to tap implementation
    cards = MTG.new(attributes).tap {|card| card.save_modern_up}
  end

  def self.create_modern_down(attributes)
    cards = MTG.new(attributes).tap {|card| card.save_modern_down}
  end

  def self.create_standard_up(attributes)
    cards = MTG.new(attributes).tap {|card| card.save_standard_up}
  end

  def self.create_standard_down(attributes)
    cards = MTG.new(attributes).tap {|card| card.save_standard_down}
  end

  def self.all(format)
    #iterate through each instance that was appended into class variable during initialization
    format.each_with_index do |card, number|
      puts ""
      puts "|- #{number + 1} -|".fg COLORS[4]
      puts ""
      #iterate through each instance method that was defined for the stored instance variable
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

  def self.format_choice(option)
    case option
      when option == 1
        self.all(@@standard_up)
      when option == 2
        self.all(@@modern_up)
      when option == 3
        self.all(@@standard_down)
      when option == 4
        self.all(@@modern_down)
    end
  end

  # def self.destroy
  #   @@all_cards.clear
  # end

  def save_modern_up
    @@modern_up << self
  end

  def save_modern_down
    @@modern_down << self
  end

  def save_standard_up
    @@standard_up << self
  end

  def save_standard_down
    @@standard_down << self
  end

end
