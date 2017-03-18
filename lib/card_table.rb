require 'bundler'
Bundler.require

DB = {:conn => SQLite3::Database.new("db/cards.db")}

class CardTable

  attr_accessor :card, :sets, :market_price, :price_fluctuate, :image

def self.table_name
  "#{self.to_s.downcase}s"
end

def self.create_table
  sql = <<-SQL
        CREATE TABLE IF NOT EXISTS #{self.table_name} (
          id INTEGER PRIMARY KEY,
          card TEXT,
          sets TEXT,
          market_price INTEGER,
          price_fluctuate TEXT,
          image TEXT
          )
          SQL

  DB[:conn].execute(sql)
end

def insert
  sql = <<-SQL
        INSERT INTO #{self.class.table_name} (card, sets, market_price, price_fluctuate, image) VALUES (?,?,?,?,?)
           SQL

  DB[:conn].execute(sql, self.card, self.sets, self.market_price, self.price_fluctuate, self.image)
end

def self.find(id)
  sql = <<-SQL
        FIND * FROM (self.class.table_name) WHERE id=(?)
        SQL

  row = DB[:conn].execute(sql, id)
  self.reify_from_row(row.first)  #using first array method to return only the first nested array
end

#opposite of abstraction is reification i.e. I'm getting the raw data of these variables
def self.reify_from_row(row.first)
  self.new.tap do |card|
    card.id = row[0]
    card.card = row[1]
    card.sets = row[2]
    card.market_price = row[3]
    card.price_fluctuate = row[4]
    card.image = row[5]
    end
end

end



# CardTable.create_table
#
# first = CardTable.new
#
# first.card = "Falkenrath"
#
# first.sets = "Innistrad"
#
# first.market_price = 23
#
# first.price_fluctuate = "+26"
#
# first.image = "ugly looking fella"
#
# first.insert
