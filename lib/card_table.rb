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
    rows = DB[:conn].execute("SELECT * FROM #{self.table_name}") #collects everything in sql table
    fname = "cards.csv" #naming the csv file
    col_names = "#{self.attributes.keys.join(", ")} \n" #collecting the table's column names
    unless File.exists? fname
      File.open(fname, 'w') do |ofile| #opening the csv file to write data into
        ofile << col_names
        rows.each_with_index {|value, index| ofile << "#{rows[index].compact.join(", ")} \n"} #pushing each array row as a newline into csv while removing nil values
        sleep(1 + rand)
      end
    end
  end

end
