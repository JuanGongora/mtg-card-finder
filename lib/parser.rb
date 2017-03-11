require 'bundler'
Bundler.require
#this combines all of my gems into one single require

class Parser
  @@overall_card_rows = nil

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
    doc = Nokogiri::HTML(open("./lib/test.html"))
    self.card_counter
    doc.css("#top50Standard tr").each do |row|
      #parsing is now initialized into MTG class, with key/value pairs for its scraped attributes
      row = MTG.new({
      card: row.css(".card a")[0].text,
      set: row.css(".set a")[0].text,
      market_price: row.css(".value")[0].text.split[0].gsub!("$", "").to_f,
      price_inflation: row.css("td:last-child").text.split[0].gsub!("+", "").to_f,
      # image: Nokogiri::HTML(open(row.css(".shop button").attribute("onclick").value.split(" ")[2].gsub!(/('|;)/, ""))).css(".detailImage img").attribute("src").value
      # ^^ had to go another level deep to access a better quality image from its full product listing
      })
    end
  end

  def self.card_counter
    #shows how many rows there are in total for the page, may come in handy later
    rows = Nokogiri::HTML(open("./lib/test.html")).css(self.select_format(option))[0..-1]
    @@overall_card_rows = "#{rows.length}".to_i
    puts "loading the top #{@@overall_card_rows} gainers on the market for today..."
    print "Please be patient"; print "."; sleep(1); print "."; sleep(1); print "."; sleep(1); print "."; sleep(1);
    puts ""
  end

  def self.select_format(option)

    case option
  when 1
    "#top50Standard tr"
  when 2
    "#top50Modern tr"
  when 3
    "#bottom50Standard tr"
  when 4
    "#bottom50Modern tr"
  else
    "You're just making that up!"
  end
end

def self.update_date
  time = Nokogiri::HTML(open("./lib/test.html"))
  time.css(".span6 h3")[0].text.split.join(" ").gsub!("Updated:", "")
end

end
