require "bundler/gem_tasks"
require 'rake/testtask'

Rake::TestTask.new do |test|
  test.pattern = 'test/*_test.rb'
  test.verbose = true
end

task :default => :test

desc "Open an irb session preloaded with this library"
task :console do
  sh "irb -rubygems -r ./lib/arsi.rb"
end
