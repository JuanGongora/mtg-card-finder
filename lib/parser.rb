require 'bundler'
Bundler.require
#this combines all of my gems into one single require

class Cards

  # def self.scrape
    # agent = Mechanize.new
    #this will help me to make the website identify what type of user is accessing the content
    #I also want to have the site understand the request that referred me to the page
    # agent.pre_connect_hooks << lambda do |agent, request|
    #     agent.user_agent = "Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/56.0.2924.87 Safari/537.36"
    #     request["Referer"] = "http://www.mtgprice.com/quickList"
    #   end
        # page = agent.get "./lib/test.html"
  #       # page.css(".card a")[0].text
  # end

  def self.scrape
    doc = Nokogiri::HTML(open("./lib/test.html"))
    doc.css(".card a")[0].text
  end
end
