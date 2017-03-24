#a dynamic module that can contain any data
module Persistable

  module ClassMethods

    def self.extended(base) #callback method where 'self' refers to this module and 'base' refers to the class that extended this module
      base.attributes.keys.each do |key|
        attr_accessor key
      end
    end

    def attributes #reader that can be accessed by Persistable module to know the unique class's constant
      self::ATTRS #scope accessing the extended class to get the constant var ATTRS
    end

    def table_name
      "#{self.to_s.downcase}s"
    end

   #this method will dynamically create additional attrs so that we can implement them into the extended class
   def create(attributes_hash)
     #the tap method allows preconfigured methods and values to
     #be associated with the instance during instantiation while also automatically returning
     #the object after its creation is concluded.
     self.new.tap do |card|
         attributes_hash.each do |key, value|
         #sending the new instance the key name as a setter with the value
         card.send("#{key}=", value)
         #string interpolation is used as the method doesn't know the key name yet
         #but an = sign is implemented into the string in order to asssociate it as a setter
       end
       card.save #saves the new instance into the database
     end
   end

    def create_table
      sql = <<-SQL
          CREATE TABLE IF NOT EXISTS #{self.table_name} ( #{self.create_sql} )
      SQL

      DB[:conn].execute(sql)
    end

    def find(id)
      sql = <<-SQL
          SELECT * FROM #{self.table_name} WHERE id=(?)
      SQL

      row = DB[:conn].execute(sql, id)
      if row.first #if a row is actually returned i.e. the id actually exists
        self.reify_from_row(row.first)
        #using .first array method to return only the first nested array
        #that is taken from self.reify_from_row(row) which is the resulting id of the query
      else
        "this card doesn't exist"
      end
    end

    #opposite of abstraction is reification i.e. I'm getting the raw data of these variables
    def reify_from_row(row)
      #the tap method allows preconfigured methods and values to
      #be associated with the instance during instantiation while also automatically returning
      #the object after its creation is concluded.
      self.new.tap do |card|
        self.attributes.keys.each.with_index do |key, index|
          #sending the new instance the key name as a setter with the value located at the 'row' index
          card.send("#{key}=", row[index])
          #string interpolation is used as the method doesn't know the key name yet
          #but an = sign is implemented into the string in order to asssociate it as a setter
        end
      end
    end

    def create_sql
      #will apply the column names ('key') and their schemas ('value') into sql strings without having to hard code them
      #the collect method returns the revised array and then we concatenate it into a string separating the contents with a comma
      self.attributes.collect {|key, value| "#{key} #{value}"}.join(", ")
    end

    def attributes_names_insert_sql
      #same idea as self.create_sql only it's returning the 'key' for sql insertions
      self.attributes.keys[1..-1].join(", ")
    end

    def question_marks_insert_sql
      questions = self.attributes.keys.size-1 #returns the number of key-value pairs in the hash minus one for the 'id'
      questions.times.collect {"?"}.join(", ") #converts them into '?' array that is then turned into comma separated string
    end

    def sql_columns_to_update
      columns = self.attributes.keys[1..-1] #returns the number of keys in the hash minus one for the 'id'
      columns.collect {|attr| "#{attr}=(?)"}.join(", ") #converts them into 'attribute=(?)' array that is then turned into comma separated string
    end

  end

  module InstanceMethods

      def destroy
        sql = <<-SQL
          DELETE FROM #{self.class.table_name} WHERE id=(?)
        SQL

        DB[:conn].execute(sql, self.id)
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

      def attribute_values_for_sql_check
        self.class.attributes.keys[1..-1].collect {|attr_names| self.send(attr_names)}
        #I go through the key names (minus 'id') and return an array containing their values for the recieving instance
        #basically like getting an array of getter methods for that instance
      end

      def persisted?
        !!self.id  #the '!!' double bang converts object into a truthy value statement
      end

      def update
        #updates by the unique identifier of 'id'
        sql = <<-SQL
           UPDATE #{self.class.table_name} SET #{self.class.sql_columns_to_update} WHERE id=(?)
        SQL

        DB[:conn].execute(sql, *attribute_values_for_sql_check, self.id) #using splat operator to signify that there may be more than one argument in terms of attr_readers
      end

      def insert
        sql = <<-SQL
          INSERT INTO #{self.class.table_name} (#{self.class.attributes_names_insert_sql}) VALUES (#{self.class.question_marks_insert_sql})
        SQL

        DB[:conn].execute(sql, *attribute_values_for_sql_check) #using splat operator to signify that there may be more than one argument in terms of attr_readers
        #after inserting the card to the database, I want to get the primary key that is auto assigned to it
        #from sql and set it to the instance method 'id' of this very instance variable.
        self.id = DB[:conn].execute("SELECT last_insert_rowid() FROM #{self.class.table_name}")[0][0] #returns first array with the first value of the array (i.e. index 0)
      end

  end

end
