# frozen_string_literal: true

require 'sinatra/activerecord/rake'
require 'rubocop/rake_task'

namespace :db do
  task :load_config do
    require_relative 'app'
  end
end

RuboCop::RakeTask.new
