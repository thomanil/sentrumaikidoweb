require 'rake'
require 'rake/testtask'

task :default => [:test]

Rake::TestTask.new do |i|
  i.test_files = FileList['test/test_*.rb']
end

desc "Deploy app to Heroku"
task :deploy do
  puts %x{ git push heroku master }
end

desc "Push new code to Github repo"
task :push do
  puts %x{ git push origin master }
end
  
desc "Pull latest code from Github repo"
task :pull do
  puts %x{ git pull origin master }
end


# Run 'rake -T' to see all available tasks
