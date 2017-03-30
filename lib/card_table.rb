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

  #reader that can be accessed by Persistable module to know the unique class's constant
  def self.attributes
    ATTRS
  end

  #abstracting the collection of keys into attributes
  self.attributes.keys.each do |key|
    attr_accessor key
  end

  def self.buy_link(id)
    name = self.find(id)
    #collect the instant's values as a string
    word = name.card + " " + name.sets
    #replace whitespace chars
    word.gsub!(/\s+/m, '%20')
    #create url for purchasing the chosen id card
    buy = "http://www.ebay.com/sch/?_nkw=#{word}&_sacat=0"
    puts buy
  end


  def self.make_csv_file
    #collects everything in sql table
    rows = DB[:conn].execute("SELECT * FROM #{self.table_name}")
    date = "#{Time.now}"[0..9].gsub!("-", "_")
    #naming the csv file with today's date
    fname = "#{date}.csv"
    #collecting the table's column names
    col_names = "#{self.attributes.keys.join(", ")} \n"
    unless File.exists? fname
      #opening the csv file to write data into
      File.open(fname, 'w') do |ofile|
        #first row will be column names
        ofile << col_names
        rows.each_with_index do |value, index|
          #iterates through all the rows values to replace commas so as to avoid line breaking errors
          value.each { |find| find.gsub!(", ", "_") if find.is_a?(String) }
          #pushing each array within rows as a newline into csv while removing nil values
          ofile << "#{rows[index].compact.join(", ")} \n"
        end
        sleep(1 + rand)
      end
    end
  end

end
