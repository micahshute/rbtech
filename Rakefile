require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

spec = Gem::Specification.find_by_name 'gspec'
load "#{spec.gem_dir}/lib/gspec/tasks/generator.rake"

task :default => :spec


task :console do 
    require_relative './lib/rbtech'
    Pry.start
end