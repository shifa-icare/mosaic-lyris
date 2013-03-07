require 'rake'
require 'rake/testtask'

task :default => [:test]

Rake::TestTask.new(:test) do |t|
  t.pattern = 'test/*_test.rb'
  t.verbose = true
end

Rake::Task[:test].comment = "Run all tests"

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "mosaic-lyris"
    gemspec.summary = "Lyris/EmailLabs API"
    gemspec.description = "A wrapper for the Lyris/EmailLabs API to simplify integration"
    gemspec.email = "brent.faulkner@mosaic.com"
    gemspec.homepage = "http://github.com/mosaicxm/mosaic-lyris"
    gemspec.authors = ["S. Brent Faulkner"]
    gemspec.add_dependency('builder')
    gemspec.add_dependency('active_support')
    gemspec.add_dependency('htmlentities')
    gemspec.add_dependency('nokogiri')
    gemspec.add_dependency('tzinfo')
    gemspec.add_development_dependency('mocha')
  end
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install jeweler"
end
