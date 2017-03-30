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

  def self.buy_link(id)
    name = self.find(id)
    word = name.card + " " + name.sets
    word.gsub!(/\s+/m, '%20')
    buy = "http://www.ebay.com/sch/?_nkw=#{word}&_sacat=0"
    puts buy
  end


  def self.make_csv_file
    rows = DB[:conn].execute("SELECT * FROM #{self.table_name}") #collects everything in sql table
    date = "#{Time.now}"[0..9].gsub!("-", "_")
    fname = "#{date}.csv" #naming the csv file with today's date
    col_names = "#{self.attributes.keys.join(", ")} \n" #collecting the table's column names
    unless File.exists? fname
      File.open(fname, 'w') do |ofile| #opening the csv file to write data into
        ofile << col_names #first row will be column names
        rows.each_with_index do |value, index|
          value.each { |find| find.gsub!(", ", "_") if find.is_a?(String) } #iterates through the row's values to replace commas so as to avoid line breaking errors
          ofile << "#{rows[index].compact.join(", ")} \n" #pushing each array row as a newline into csv while removing nil values
        end
        sleep(1 + rand)
      end
    end
  end

end
