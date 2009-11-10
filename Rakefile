begin
  require 'jeweler'
  Jeweler::Tasks.new do |s|
    s.name     = "fancystruct"
    s.homepage = "http://github.com/quackingduck/fancystruct"
    s.summary  = "Like Struct, but fancy"
    s.email    = "myles@myles.id.au"
    s.authors  = ["Myles Byrne"]
    
    s.add_development_dependency 'exemplor', '>= 2000.0.0'
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Install jeweler to build gem"
end

task :default => [:examples]
task(:examples) { ruby "examples.rb" }

