class Scraper
  @@overall_set_options = nil
  @@overall_card_rows = nil
  @@iterator = []
  @@set_sum = -1

  #same idea here as self.scrape_cards, only I'm parsing for sets this time
  def self.scrape_set_options
    doc = Nokogiri::HTML(open("http://prices.tcgplayer.com/price-guide/magic"))
    #call Scraper.set_counter to get the total amount of sets first
    self.set_counter
    self.iterating(@@overall_set_options)
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

 def self.iterating(array_length)
   #cleans out the var before it's re-used again
   @@iterator.clear
   #the class variable @@iterator is converted into a numerical array depicting the amount of sets/cards
   @@iterator = (0..array_length).to_a
 end

  #same concept as Scraper.card_counter
  def self.set_counter
    options = Nokogiri::HTML(open("http://prices.tcgplayer.com/price-guide/magic")).css("#set option")[0..-1]
    @@overall_set_options = "#{options.length}".to_i
    puts "loading #{@@overall_set_options} sets..."
  end

  def self.card_counter
    #shows how many rows there are in total for the page, may come in handy later
    rows = Nokogiri::HTML(open("http://prices.tcgplayer.com/price-guide/magic")).css("tbody tr")[0..-1]
    @@overall_card_rows = "#{rows.length}".to_i
    puts "loading #{@@overall_card_rows} cards..."
  end

end
