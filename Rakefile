require_relative './lib/parser'

def reload!
  load_all './lib'
  load_all './db'
  load_all './fixtures'
end

task :console do
  Pry.start
end
