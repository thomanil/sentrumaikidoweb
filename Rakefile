require 'rake'
require 'rake/testtask'

task :default => [:test]

Rake::TestTask.new do |i|
  i.test_files = FileList['test/test_*.rb']
  #i.verbose = true
end

desc "Deploy app to Heroku"
task :deploy do
  puts %x{ git push heroku master }
end

  


