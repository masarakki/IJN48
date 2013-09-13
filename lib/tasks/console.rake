require 'pry'

desc 'start debug console'
task :console do
  $:.unshift 'lib'
  require 'naka'
  user = Naka::User.first
  binding.pry
end
