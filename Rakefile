#!/usr/bin/env rake

$:.unshift(File.expand_path(File.dirname(__FILE__) + '/lib'))
require 'naka'
require 'rake'
require 'rspec/core/rake_task'
require 'resque/tasks'

RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end
Dir["./lib/tasks/**/*.rake"].each{|ext| load ext }

task :default => :spec
