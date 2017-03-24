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

  self.attributes.keys.each do |key|
    attr_accessor key
  end
end
