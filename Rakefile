require 'bundler/setup'
require 'bundler/gem_tasks'
require 'rake/testtask'
require 'wwtd/tasks'

Rake::TestTask.new do |test|
  test.pattern = 'test/*_test.rb'
  test.verbose = true
end

task :default => "wwtd:local"

# Usage: rake bump:patch && rake tag
task :tag do
  require 'bump'
  version = Bump::Bump.current
  puts "tagging and pushing v#{version}"
  sh "git pull && git push && git tag v#{version} && git push --tags"
end
