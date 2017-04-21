class MTGCardFinder::Parser
  @@overall_card_rows = nil
  @@overall_format_options = []
  @@time_review = []

  def self.scrape_cards
    self.card_counter
    #checks if the class variable array for the MTG class is empty or not
    if @@overall_format_options[9].call.empty? == false
      #if user has already parsed the same content before, then scrape the locally stored variables instead of the website
      MTG.store_temp_array(@@overall_format_options[9].call)
    else @@overall_format_options[9].call.empty? == true
      #creates a new sql table for gathering the 'to be' scraped content
      @@overall_format_options[5].call
      #exception handling block implemented for possible errors (i.e. website is down)
      retries = 3
      #'retries' will hold the amount of attempts done to block until it quits if a scraping error is not resolved
      begin
        agent = Mechanize.new
        #'agent' will help me to make the website identify what type of user is accessing the content
        #I also want to have the site understand the request that referred me to the page
        agent.pre_connect_hooks << lambda do |agent, request|
          agent.user_agent = "Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/56.0.2924.87 Safari/537.36"
          request["Referer"] = "http://www.mtgprice.com/"
        end
        #browser parsing begins in local variable 'doc'
        doc = agent.get "http://www.mtgprice.com/taneLayout/mtg_price_tracker.jsp?period=DAILY"
      rescue StandardError=>e
        puts "Error: #{e}"
        #implementing additonal retry to see if a resolution can be attained by reconnecting to site
        if retries > 0
          puts "Trying #{retries} more times"
          retries -= 1
          sleep 1
          retry
        else
          puts "Unable to resolve #{e}"
        end
      else
        #if no error was attained from 'begin' of block till now, then the card scraping commences
        doc.css(@@overall_format_options[0]).each do |row|
          #parsing is now initialized into MTG class, with key/value pairs for its scraped attributes
          row = self.parser_format(hash = {
              card: row.css(".card a")[0].text,
              sets: row.css(".set a")[0].text,
              market_price: row.css(".value")[0].text.split[0].gsub!("$", "").to_f,
              price_fluctuate: row.css("td:last-child").text,
              image: Nokogiri::HTML(open("http://www.mtgprice.com#{row.css(".card a").attribute("href").value}")).css(".card-img img").attribute("src").value
              # ^^ had to go another level deep to access a better quality image from its full product listing
          })
          #since a stored method in an array can't have a locally passed argument I compromised by just having the class name passed from the class variable array to the method
          #I also make sure that no duplicate information may be transferred into the table by comparing the card row/number count
          @@overall_format_options[6].create(hash) if @@overall_format_options[6].table_rows < self.table_length
        end
      ensure
        sleep(0.3)
      end
    end
  end

  def self.card_counter
    @@overall_card_rows = nil
    #shows how many rows(amount of cards) there are in total for the page as a constructed array
    rows = Nokogiri::HTML(open("http://www.mtgprice.com/taneLayout/mtg_price_tracker.jsp?period=DAILY")).css(@@overall_format_options[0])[0..-1]
    @@overall_card_rows = "#{rows.length}".to_i
    puts "loading the #{@@overall_format_options[1]} #{@@overall_card_rows} #{@@overall_format_options[2]} #{@@overall_format_options[3]} on the market for today..."; sleep(1);
    print "Please be patient"; print "."; sleep(1); print "."; sleep(1); print "."; sleep(1); print "."; sleep(1);
    puts ""
    puts ""
    puts "-------------------------------------------------"
    puts ""
    puts "                                                 ".bg COLORS[7]
  end

  def self.select_format
    @@overall_format_options.clear
    input = gets.strip.to_i
    case input
      when 1
        #the methods at the end of these arrays are stored references that can be called externally with the .call method #=>  http://stackoverflow.com/questions/13948910/ruby-methods-as-array-elements-how-do-they-work
        @@overall_format_options = ["#top50Standard tr", "top", "Standard", "#{"gainers".fg COLORS[4]}", StandardRise.method(:remove_table), StandardRise.method(:create_table), StandardRise, StandardRise.method(:make_csv_file), MTG.method(:search_standard_up), MTG.method(:standard_up)]
      when 2
        @@overall_format_options = ["#top50Modern tr", "top", "Modern", "#{"gainers".fg COLORS[4]}", ModernRise.method(:remove_table), ModernRise.method(:create_table), ModernRise, ModernRise.method(:make_csv_file), MTG.method(:search_modern_up), MTG.method(:modern_up)]
      when 3
        @@overall_format_options = ["#bottom50Standard tr", "bottom", "Standard", "#{"crashers".fg COLORS[6]}", StandardFall.method(:remove_table), StandardFall.method(:create_table), StandardFall, StandardFall.method(:make_csv_file), MTG.method(:search_standard_down), MTG.method(:standard_down)]
      when 4
        @@overall_format_options = ["#bottom50Modern tr", "bottom", "Modern", "#{"crashers".fg COLORS[6]}", ModernFall.method(:remove_table), ModernFall.method(:create_table), ModernFall, ModernFall.method(:make_csv_file), MTG.method(:search_modern_down), MTG.method(:modern_down)]
      else
        CLI.set_input
    end
  end

  #used within self.scrape_cards, it assists with the assigning of instances to the preferred class variable in MTG
  def self.parser_format(attributes)
    if self.format_name == "StandardRise"
      MTG.create_standard_up(attributes)
    elsif self.format_name == "ModernRise"
      MTG.create_modern_up(attributes)
    elsif self.format_name == "StandardFall"
      MTG.create_standard_down(attributes)
    else self.format_name == "ModernFall"
      MTG.create_modern_down(attributes)
    end
  end

  def self.display_cards
    @@overall_format_options[8].call
  end

  def self.format_name
    "#{@@overall_format_options[6]}"
  end

  def self.table_length
    @@overall_card_rows
  end

  def self.purchase
    input = gets.strip.to_i
    @@overall_format_options[6].buy_link(input)
  end

  def self.csv
    #Klass.make_csv_file
    @@overall_format_options[7].call
    puts ""
    puts "The #{"CSV".fg COLORS[3]} file has been saved to your hard disk"
    puts "---------------------------------------------"
    puts ""
  end

  def self.update_date
    time = Nokogiri::HTML(open("http://www.mtgprice.com/taneLayout/mtg_price_tracker.jsp?period=DAILY"))
    time.css(".span6 h3")[0].text.split.join(" ").gsub!("Updated:", "")
  end

  #used to clear the tables so that the next re-run will have new, updated content from the website
  def self.reset_query_info
    @@time_review = [StandardRise.method(:remove_table), ModernRise.method(:remove_table), StandardFall.method(:remove_table), ModernFall.method(:remove_table)]
    @@time_review.each_with_index {|method, index| @@time_review[index].call}
  end

end
