require_relative 'config/environment' #everything is being operated from within here

task :console do #cutsom console initialization for testing

  def reload! #lets me load all my files again if I make a change
    load_all 'lib'
  end

  Pry.start #allows pry to start for me to fiddle around with all my methods

end
