class MTGCardFinder::CLI

  def self.start
    Parser.reset_query_info
    puts "Powered by MTG$ (mtgprice.com)"; sleep(0.5);
    puts "-------------------------------------------------"
    puts "Please select your price trend Format:"
    puts "-------------------------------------------------"
    puts "#{"|Last Update|".fg COLORS[6]}#{Parser.update_date}"
    puts "-------------------------------------------------"
    self.set_choosing
  end

  def self.set_text
    puts "#{"[1]".fg COLORS[3]} Standard: #{"rising".fg COLORS[4]} cards today"
    puts "#{"[2]".fg COLORS[3]} Modern: #{"rising".fg COLORS[4]} cards today"
    puts "#{"[3]".fg COLORS[3]} Standard: #{"crashing".fg COLORS[6]} cards today"
    puts "#{"[4]".fg COLORS[3]} Modern: #{"crashing".fg COLORS[6]} cards today"
    puts "-------------------------------------------------"
  end

  def self.options_text
    puts "Would you like to?"
    puts "#{"[1]".fg COLORS[3]} search for a different format's market?"
    puts "#{"[2]".fg COLORS[3]} save the current card search listing into a CSV file?"
    puts "#{"[3]".fg COLORS[3]} purchase one of the queried cards in the open market?"
    puts "#{"[4]".fg COLORS[3]} exit the program?"
    puts "-------------------------------------------------"
  end

  def self.set_choosing
    self.set_text
    self.set_input
    Parser.scrape_cards
    Parser.display_cards
    puts ""
    puts "-------------------------------------------------"
    puts ""
    self.options_text
    self.options_input
  end

  def self.set_input
    sleep(1)
    puts "Please type out the #{"number".fg COLORS[3]} of the format you would like to see from above..."
    Parser.select_format
  end

  def self.options_input
    input = gets.strip.to_i
    if input == 1
      puts "Please select your price trend Format:"
      self.set_choosing
    elsif input == 2
      Parser.csv
      sleep(2)
      self.options_text
      self.options_input
    elsif input == 3
      puts "Please type out the #{"number".fg COLORS[4]} from one of the above searched cards:"
      Parser.purchase
      sleep(2.5)
      self.options_text
      self.options_input
    elsif input == 4
      puts ""
      puts ""
      puts "Thank you for using #{"MTG".fg COLORS[6]} #{"CARD".fg COLORS[5]} #{"FINDER".fg COLORS[4]}"
      puts "-----------------------------------"
      exit
    else
      puts "That is not a valid option"
      self.options_input
    end
  end

end
