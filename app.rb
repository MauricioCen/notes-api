# frozen_string_literal: true

require 'bundler/setup'
Bundler.require(:default, ENV['RACK_ENV'])

class Note < ActiveRecord::Base
end

class User < ActiveRecord::Base
end

class NoteSerializer < Blueprinter::Base
  identifier :id
  fields :name, :created_at
end

class UserSerializer < Blueprinter::Base
  identifier :id
  fields :name, :last_name, :email, :created_at
end

class NoteContract < Dry::Validation::Contract
  params do
    required(:name).filled(:string)
  end
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
    contract = NoteContract.new.call(params)
    halt 422, (json errors: contract.errors.to_h) if contract.failure?
    note = Note.create!(params)
    status 201
    json NoteSerializer.render_as_hash(note)
  end

  put '/notes/:id' do
    note = Note.find_by(id: params[:id])
    halt 404 if note.nil?
    contract = NoteContract.new.call(params)
    halt 422, (json errors: contract.errors.to_h) if contract.failure?
    note.update!(params)
    json NoteSerializer.render_as_hash(note)
  end

  delete '/notes/:id' do
    Note.find_by(id: params[:id])&.destroy!
    halt 204
  end

  get '/users' do
    users = User.all
    json UserSerializer.render_as_hash(users)
  end

  get '/users/:id' do
    user = User.find_by(id: params[:id])
    halt 404 if user.nil?
    json UserSerializer.render_as_hash(user)
  end

  post '/users' do
    user = User.create!(params)
    status 201
    json UserSerializer.render_as_hash(user)
  end

  put '/users/:id' do
    user = User.find_by(id: params[:id])
    halt 404 if user.nil?
    user.update!(params)
    json UserSerializer.render_as_hash(user)
  end
  delete '/users/:id' do
    User.find_by(id: params[:id])&.destroy!
    halt 204
  end
end
