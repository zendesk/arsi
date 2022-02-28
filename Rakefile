require 'bundler/setup'
require 'bundler/gem_tasks'
require 'rake/testtask'
require 'bump/tasks'

Rake::TestTask.new do |test|
  test.pattern = 'test/*_test.rb'
  test.verbose = true
end

task default: :test

desc "Bundle all gemfiles"
task :bundle_all do
  extra = ENV["EXTRA"]
  Bundler.with_original_env do
    Dir["gemfiles/*.gemfile"].each do |gemfile|
      sh "BUNDLE_GEMFILE=#{gemfile} bundle #{extra}"
    end
  end
end
