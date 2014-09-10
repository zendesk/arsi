require "bundler/gem_tasks"
require 'rake/testtask'

Rake::TestTask.new do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/unit/test_*.rb'
  test.verbose = true
end

task :default do
  sh "bundle exec rake test"
end
