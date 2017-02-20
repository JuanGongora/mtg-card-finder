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
  #associated to self.set_amount below
  @@set_iterator = nil

  #same methodology of initialization as class MTG
  def initialize(attributes)
    attributes.each {|key, value| self.send("#{key}=", value)}
    @@all_sets << self
  end

  def self.set_amount
    #this was a method that I was testing to get values of only odd numbers
    #may or may not use this, I'll keep it here for now and see if I might need it
    amount = @@all_sets.length
    @@set_iterator = (0..amount).step(2).to_a
  end

  #I am iterating through the stored sets of @@all_sets to return
  #the first value which is the name of the set, along with the set number
  def self.all
    @@all_sets.each_with_index do |set, number|
      #this line below is applied simply to help me parse the values of the two instances seperately further down the code
      if number.even?
        set.instance_variables.each_with_index do |value, index|
          #I only want to return the first value as the viewable option
          #the second value is the url for loading the set, which
          #I will later use to load the preconfigured webpage for card parsing
          puts "-                                                                                           -"
          if index < 1
            #I iterate the index of @@all_sets(with the title of 'number') to apply it as a string for logging enumeration
            #in both the actual set number and the value of the first instance method of the current index's instance
            puts "|Set-#{number + 1}| #{@@all_sets[number].instance_variable_get(value)}  |Set-#{number + 2}| #{@@all_sets[number + 1].instance_variable_get(value)}"
          end
          puts "---------------------------------------------------------------------------------------------"
        end
      end
    end
  end

end


class Scraper
  @@overall_set_options = nil
  @@overall_card_rows = nil
  @@iterator = nil
  @@set_sum = -1

  #same idea here as self.scrape_cards, only I'm parsing for sets this time
  def self.scrape_set_options
    doc = Nokogiri::HTML(open("http://prices.tcgplayer.com/price-guide/magic"))
    #call Scraper.set_counter to get the total amount of sets first
    self.set_counter
    #the class variable @@iterator is converted into a numerical array depicting the amount of sets
    @@iterator = (0..@@overall_set_options).to_a
    #I parse through the index numbers of the css selectors "[0].text" and "[0].attribute" to increase *
    #their index in proportion to @@iterator's count
    @@iterator.each do |count|
      #increment by 1 everytime it parses so as to have the right index value in the css selectors (described above)*
      count = @@set_sum += 1
      doc.css("#set").each_with_index do |option, index|
        index = @@set_sum
        #if my incremented value from "count" is less than the total amount of sets, continue operation
        if index < @@overall_set_options
          option = Set.new({
                       set: option.css("option")[index].text.split.join(" "),
                       set_url: "http://prices.tcgplayer.com/price-guide/magic/#{option.css("option")[index].attribute("value").value}"
                       })
        end
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
# Scraper.set_counter # => returns 193 sets in total
# Scraper.counter # => returns 198 rows(i.e. cards) for the 'set' Aether Revolt
