# frozen_string_literal: true

require 'sinatra/base'
require 'sinatra/activerecord'
require 'sinatra/contrib/all'
require 'rack/contrib'
require 'blueprinter'

class Note < ActiveRecord::Base
end

class NoteSerializer < Blueprinter::Base
  identifier :id
  fields :name, :created_at
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
    notes = Note.all
    json NoteSerializer.render_as_hash(notes)
  end

  get '/notes/:id' do
    note = Note.find_by(id: params[:id])
    halt 404 if note.nil?
    json NoteSerializer.render_as_hash(note)
  end

  post '/notes' do
    note = Note.create!(params)
    status 201
    json NoteSerializer.render_as_hash(note)
  end

  put '/notes/:id' do
    note = Note.find_by(id: params[:id])
    halt 404 if note.nil?
    note.update!(params)
    json NoteSerializer.render_as_hash(note)
  end

  delete '/notes/:id' do
    Note.find_by(id: params[:id])&.destroy!
    halt 204
  end
end
