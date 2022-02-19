# frozen_string_literal: true

require 'sinatra/base'
require 'sinatra/activerecord'

class Note < ActiveRecord::Base
end

class App < Sinatra::Base
  register Sinatra::ActiveRecordExtension
  set :database, { adapter: 'sqlite3', database: "#{environment}.sqlite3" }

  get '/' do
    'Hello world!'
  end

  get '/items' do
    'Get all items'
  end

  get '/items/:id' do
    params[:id]
  end

  post '/items' do
    'create items'
  end

  put '/items/:id' do
    params[:id]
  end

  delete '/items/:id' do
    params[:id]
  end
end
