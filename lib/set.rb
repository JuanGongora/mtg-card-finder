#each card comes from a 'card set', and there are various sets that span years of production
#since I want to have a hierarchy that allows searching of cards per set I'm making
#a similar functionality to that of class MTG with this new class 'Set'
class Set
  attr_accessor :set, :set_url
  @@all_sets = []
  #associated to self.set_amount below
  @@set_iterator = nil

  #same methodology of initialization as class MTG
  def initialize(attributes)
    attributes.each {|key, value| self.send("#{key}=", value)}
    @@all_sets << self
  end

  def self.set_amount
    #will use this to help me get user to choose a currently existing set number
    amount = @@all_sets.length
    @@set_iterator = (1..amount).to_a
  end

  def self.set_name(value)
    @@all_sets[value - 1].set
  end

  def self.set_name_url(value)
    @@all_sets[value - 1].set_url
  end
  #I am iterating through the stored sets of @@all_sets to return
  #the first value which is the name of the set, along with the set number
  def self.all
    @@all_sets.each_with_index do |set, number|
      #this line below is applied simply to help me parse the values of the two instances seperately further down the code
      if number.even?
        set.instance_variables.each_with_index do |value, index|
          #I only want to return the first value as the viewable option
          #the second value is the url for loading the set, which
          #I will later use to load the preconfigured webpage for card parsing
          puts "-                                                                                           -"
          if index < 1
            #I iterate the index of @@all_sets(with the title of 'number') to apply it as a string for logging enumeration
            #in both the actual set number and the value of the first instance method of the current index's instance
            puts "|Set-#{number + 1}| #{@@all_sets[number].instance_variable_get(value)}  |Set-#{number + 2}| #{@@all_sets[number + 1].instance_variable_get(value)}"
          end
          puts "---------------------------------------------------------------------------------------------"
        end
      end
    end
  end

end
