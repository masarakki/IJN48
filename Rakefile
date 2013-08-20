#!/usr/bin/env rake

require 'rake'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end
Dir["./lib/tasks/**/*.rake"].each{|ext| load ext }

task :default => :spec
