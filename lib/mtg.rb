class MTG
  attr_accessor :card, :sets, :market_price, :price_fluctuate, :format#, :image
  @@all_cards = []
  @@digit_counter = 0
  @@iterator = []
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
      if "#{card.format}" == Parser.format_name
        puts ""
        puts "-------------------------------------------------"
        puts "|- #{(@@digit_counter == Parser.table_length) ? @@digit_counter = 1 : @@digit_counter += 1} -|".fg COLORS[4]
        puts ""
        card.instance_variables.each_with_index do |value, index|
          #returns the value of the instance method applied to the instance
          #with an index value of the first/last, key/value pairs ordered in Scraper.scrape_cards(set_url)
          #associates a named definition of the values by titling it from constant ATTRIBUTES
          if index < 4
            puts "#{ATTRIBUTES[index].fg COLORS[2]} #{card.instance_variable_get(value)}"
          end
        end
        puts ""
        puts "-------------------------------------------------"
        print "                                                 ".bg COLORS[7]
      else
        nil
      end
    end
  end

  def self.finder(id)
    sql = <<-SQL
        SELECT * FROM modernfalls WHERE id=(?)
    SQL

    row = DB[:conn].execute(sql, id)
    puts row
    # if a row is actually returned i.e. the id actually exists
    #   if row.first
    #     self.reify_from_row(row.first)
    #     #using .first array method to return only the first nested array
    #     #that is taken from self.reify_from_row(row) which is the resulting id of the query
    #   else
    #     puts "This card does not exist"
    #   end
  end

  # def self.reify_from_row(row)
  #   #the tap method allows preconfigured methods and values to
  #   #be associated with the instance during instantiation while also automatically returning
  #   #the object after its creation is concluded.
  #   self.new.tap do |card|
  #     self.attributes.keys.each.with_index do |key, index|
  #       #sending the new instance the key name as a setter with the value located at the 'row' index
  #       card.send("#{key}=", row[index])
  #       #string interpolation is used as the method doesn't know the key name yet
  #       #but an = sign is implemented into the string in order to asssociate it as a setter
  #     end
  #   end
  # end


  def self.iterating(array_length)
    #cleans out the var before it's re-used again
    @@iterator.clear
    #the class variable @@iterator is converted into a numerical array depicting the amount of sets/cards
    @@iterator = (0..array_length).to_a
  end

  def self.why
    MTG.iterating(Parser.table_length)
    #I parse through the index numbers of the css selectors "[0].text" and "[0].attribute" to increase *
    #their index in proportion to @@iterator's count
      #increment by 1 everytime it parses so as to have the right index value in the css selectors (described above)*
      @@iterator.each_with_index do |option, index|
        index = @@digit_counter += 1
        #if my incremented value from "count" is less than the total amount of sets, continue operation
        unless index > Parser.table_length
          MTG.finder(index)
        end
      end
    end

end
