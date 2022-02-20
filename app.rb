# frozen_string_literal: true

require 'sinatra/base'
require 'sinatra/activerecord'
require 'sinatra/contrib/all'
require 'rack/contrib'

class Note < ActiveRecord::Base
end

class App < Sinatra::Base
  register Sinatra::ActiveRecordExtension
  set :database, { adapter: 'sqlite3', database: "#{environment}.sqlite3" }
  configure :development do
    register Sinatra::Reloader
  end

  get '/' do
    'Hello world!'
  end

  get '/notes' do
    json Note.all
  end

  get '/notes/:id' do
    note = Note.find_by(id: params[:id])
    halt 404 if note.nil?
    json note
  end

  post '/notes' do
    note = Note.create!(params)
    status 201
    json note
  end

  put '/notes/:id' do
    note = Note.find_by(id: params[:id])
    halt 404 if note.nil?
    note.update!(params)
    json note
  end

  delete '/notes/:id' do
    Note.find_by(id: params[:id])&.destroy!
    halt 204
  end
end
