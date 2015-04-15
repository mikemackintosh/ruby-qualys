#encoding: utf-8 
require "bundler/gem_tasks"
require 'rspec/core/rake_task'
require 'rubocop/rake_task'

task :default => :test

RSpec::Core::RakeTask.new do |spec|
  spec.verbose = false
  spec.pattern = './spec/{*/**/}*_spec.rb'
end

task :test do
  ENV['RACK_ENV'] = 'test'

  require './spec/spec_helper'
  Rake::Task['spec'].invoke
end

desc 'Run RuboCop on the lib directory'
RuboCop::RakeTask.new(:rubocop) do |task|
  task.patterns = ['lib/**/*.rb']
  # only show the files with failures
  task.formatters = ['progress']
  # don't abort rake on failure
  task.fail_on_error = false
end