require 'bundler'
Bundler.require
#this combines all of my gems into one single require

class Cards

  def self.scrape
    agent = Mechanize.new
    #this will help me to make the website identify what type of user is accessing the content
    #I also want to have the site understand the request that I want to keep access to
    agent.pre_connect_hooks << lambda do |agent, request|
        agent.user_agent = "Ruby/#{RUBY_VERSION}"
        request["Referer"] = "http://www.mtgprice.com/quickList"
      end
        page = agent.get "http://www.mtgprice.com/taneLayout/mtg_price_tracker.jsp?period=DAILY"
        page.css(".card a")[0].text
  end

end
