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

  # def self.make_text_file
  #   local_fname = "cards.txt"
  #   File.open(local_fname, "w"){|file| file.write(open("db/cards.db").read)}
  # end

  def self.make_csv_file
    sym = DB[:conn].execute("SELECT * FROM #{self.table_name}")
    fname = "card.csv"
    unless File.exists? fname
      File.open(fname, 'w') do |ofile|
        ofile.write(sym)
        sleep(1.5 + rand)
      end
    end
  end

end
