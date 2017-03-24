require 'bundler'
Bundler.require

DB = {:conn => SQLite3::Database.new("db/cards.db")}

class CardTable
  include Persistable::InstanceMethods
  extend Persistable::ClassMethods

  #metaprogramming the hash to convert keys to attr_accessor's and also for inserting the values to the sql strings
  ATTRS = {
    :id => "INTEGER PRIMARY KEY",
    :card => "TEXT",
    :sets => "TEXT",
    :market_price => "INTEGER",
    :price_fluctuate => "TEXT",
    :image => "TEXT"
  }

  def self.attributes #reader that can be accessed by Persistable module to know the unique class's constant 
    ATTRS
  end

  ATTRS.keys.each do |key|
    attr_accessor key
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

first.sets = "legos"

first.save

first.save

puts CardTable.find(1)

puts CardTable.find(2)
