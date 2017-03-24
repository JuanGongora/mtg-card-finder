class Parser
  @@overall_card_rows = nil
  @@overall_format_options = []

  # def self.scrape
    # agent = Mechanize.new
    #this will help me to make the website identify what type of user is accessing the content
    #I also want to have the site understand the request that referred me to the page
    # agent.pre_connect_hooks << lambda do |agent, request|
    #     agent.user_agent = "Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/56.0.2924.87 Safari/537.36"
    #     request["Referer"] = "http://www.mtgprice.com/quickList"
    #   end
        # page = agent.get "./lib/test.html"
        # page.css(".card a")[0].text
  # end

  def self.scrape_cards
    doc = Nokogiri::HTML(open("./fixtures/test.html"))
    self.card_counter
    doc.css(@@overall_format_options[0]).each do |row|
      #parsing is now initialized into MTG class, with key/value pairs for its scraped attributes
      row = MTG.new({
      card: row.css(".card a")[0].text,
      sets: row.css(".set a")[0].text,
      market_price: row.css(".value")[0].text.split[0].gsub!("$", "").to_f,
      price_fluctuate: row.css("td:last-child").text
      #image: Nokogiri::HTML(open("./fixtures/cards.html")).css(".card-img img").attribute("src").value

      # image: Nokogiri::HTML(open("http://www.mtgprice.com#{row.css(".card a").attribute("href").value}")).css(".card-img img").attribute("src").value
      # ^^ had to go another level deep to access a better quality image from its full product listing
      })
    end
  end

  def self.card_counter
    @@overall_card_rows = nil
    #shows how many rows there are in total for the page, may come in handy later
    rows = Nokogiri::HTML(open("./fixtures/test.html")).css(@@overall_format_options[0])[0..-1]
    @@overall_card_rows = "#{rows.length}".to_i
    puts "loading the #{@@overall_format_options[1]} #{@@overall_card_rows} #{@@overall_format_options[2]} #{@@overall_format_options[3]} on the market for today..."; sleep(1);
    print "Please be patient"; print "."; sleep(1); print "."; sleep(1); print "."; sleep(1); print "."; sleep(1);
    puts ""
  end

  def self.select_format
    @@overall_format_options.clear
    # input = gets.strip.to_i
        input = 1
    case input
      when 1
        @@overall_format_options = ["#top50Standard tr", "top", "Standard", "#{"gainers".fg COLORS[4]}"]
      when 2
        @@overall_format_options = ["#top50Modern tr", "top", "Modern", "#{"gainers".fg COLORS[4]}"]
      when 3
        @@overall_format_options = ["#bottom50Standard tr", "bottom", "Standard", "#{"crashers".fg COLORS[6]}"]
      when 4
        @@overall_format_options = ["#bottom50Modern tr", "bottom", "Modern", "#{"crashers".fg COLORS[6]}"]
      else
        CLI.check_input
    end
  end

def self.update_date
  time = Nokogiri::HTML(open("./fixtures/test.html"))
  time.css(".span6 h3")[0].text.split.join(" ").gsub!("Updated:", "")
end

end
