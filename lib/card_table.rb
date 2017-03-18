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

def save
  sql = <<-SQL
        INSERT INTO #{self.table_name} (card, sets, market_price, price_fluctuate, image) VALUES (?,?,?,?,?)
           SQL

  DB[:conn].execute(sql)
end


end
