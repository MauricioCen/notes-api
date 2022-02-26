# frozen_string_literal: true

require 'sinatra/activerecord/rake'
require 'rubocop/rake_task'
require 'rake/testtask'

namespace :db do
  task :load_config do
    require_relative 'app'
  end
end

Rake::TestTask.new do |task|
  task.pattern = 'test/**/*_test.rb'
  task.warning = false
end

RuboCop::RakeTask.new
