require 'bundler'
Bundler.require

DB = {:conn => SQLite3::Database.new("db/cards.db")}

class CardTable

  #metaprogramming the hash to convert keys to attr_accessor's and also for inserting the values to the sql strings
  ATTRS = {
    :id => "INTEGER PRIMARY KEY",
    :card => "TEXT",
    :sets => "TEXT",
    :market_price => "INTEGER",
    :price_fluctuate => "TEXT",
    :image => "TEXT"
  }

  ATTRS.keys.each do |key|
    attr_accessor key
  end

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

  def self.find(id)
    sql = <<-SQL
        SELECT * FROM #{self.table_name} WHERE id=(?)
    SQL

    row = DB[:conn].execute(sql, id)
    self.reify_from_row(row.first)
    #using first array method to return only the first nested array
    #that is taken from self.reify_from_row(row) which is the resulting id of the query
  end

  #opposite of abstraction is reification i.e. I'm getting the raw data of these variables
  def self.reify_from_row(row)
    #the tap method allows preconfigured methods and values to
    #be associated with the instance during instantiation while also automatically returning
    #the object after it's creation is concluded.  
    self.new.tap do |card|
      ATTRS.keys.each.with_index do |key, index|
        #sending the new instance the key name as a setter with the value located at the 'row' index
        card.send("#{key}=", row[index])
        #string interpolation is used as the method doesn't know the key name yet
        #but an = sign is implemented into the string in order to asssociate it as a setter
      end
    end
  end

  #the website below gives an excellent explanation to how this method works
  # http://www.blackbytes.info/2017/03/ruby-equality/?tl_inbound=1&tl_target_all=1&tl_form_type=1&tl_period_type=1
  def ==(other_card)
    self.id == other_card.id
  end

  def save
    #if the card has already been saved, then call update method
    persisted? ? update : insert
    #if not call insert method instead
  end

  private #the below methods don't need to be accessed by the user

  def persisted?
    !!self.id  #the '!!' double bang converts object into a truthy value statement
  end

  #updates by the unique identifier of 'id'
  def update
    sql = <<-SQL
       UPDATE #{self.class.table_name} SET card=(?), sets=(?), market_price=(?), price_fluctuate=(?), image=(?) WHERE id=(?)
    SQL

    DB[:conn].execute(sql, self.card, self.sets, self.market_price, self.price_fluctuate, self.image, self.id)
  end

  def insert
    sql = <<-SQL
      INSERT INTO #{self.class.table_name} (card, sets, market_price, price_fluctuate, image) VALUES (?,?,?,?,?)
    SQL

    DB[:conn].execute(sql, self.card, self.sets, self.market_price, self.price_fluctuate, self.image)
    #after inserting the card to the database, I want to get the primary key that is auto assigned to it
    #from sql and set it to the instance method 'id' of this very instance variable.
    self.id = DB[:conn].execute("SELECT last_insert_rowid();").flatten.first #returns a new array that is a one-dimensional flattening of this array with the first value for it
  end

end


CardTable.create_table

first = CardTable.new

first.card = "Falkenrath"

first.sets = "Innistrad"

first.market_price = 23

first.price_fluctuate = "+26"

first.image = "ugly looking fella"

first.save

puts CardTable.find(1)
