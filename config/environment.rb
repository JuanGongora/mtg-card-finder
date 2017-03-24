require 'bundler'
Bundler.require
#this combines all of my gems into one single require

DB = {:conn => SQLite3::Database.new("db/cards.db")}

require_all 'lib'


#testing
CardTable.create_table

first = CardTable.new

first.card = "Falkenrath"

first.sets = "Innistrad"

first.market_price = 23

first.price_fluctuate = "+26"

first.image = "ugly looking monkey"

first.save

first.sets = "margarine"

first.save

first.save

puts CardTable.find(1)

puts CardTable.find(2)
