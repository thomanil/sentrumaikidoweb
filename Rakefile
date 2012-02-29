require 'rake'
require 'rake/testtask'

task :default => [:test]


desc "Run unit tests."
task :test do
  puts %x{ ruby -rubygems test/tests.rb}
end

desc "Deploy app to Heroku"
task :deploy do
  puts %x{ git push heroku master }
end

  


