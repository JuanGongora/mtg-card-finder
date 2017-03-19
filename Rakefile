require_relative './lib/cli'

def reload!
  load_all './lib'
  load_all './db'
  load_all './fixtures'
end

task :console do
  Pry.start
end
