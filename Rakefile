require "bundler/gem_tasks"
require 'rake/testtask'

Rake::TestTask.new do |test|
  test.pattern = 'test/*_test.rb'
  test.verbose = true
end

task :default => :test

# Usage: rake bump:patch && rake tag
task :tag do
  require 'bump'
  version = Bump::Bump.current
  puts "tagging and pushing v#{version}"
  `git pull --rebase && git push && git tag v#{version} && git push --tags`
end
