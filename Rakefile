require 'rake'
require 'rake/testtask'

task :default => [:help]

desc "Show available tasks"
task :help do
  puts "\nAvailable rake tasks:"
  puts %x{ rake -T}
  puts "\nNote: To start up a local development server, run 'scripts/server' from this dir.\n\n"
end


Rake::TestTask.new do |i|
  i.test_files = FileList['test/test_*.rb']
end

desc "Deploy app to Heroku"
task :deploy do
  puts %x{ git push git@heroku.com:sentrumaikido.git master }
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
