# frozen_string_literal: true

require 'bundler/setup'
Bundler.require(:default, ENV['RACK_ENV'])

require 'pagy/extras/metadata'
require 'pagy/extras/overflow'

Pagy::DEFAULT[:items]    = 5
Pagy::DEFAULT[:metadata] = %i[items count page pages]
Pagy::DEFAULT[:overflow] = :empty_page

class Note < ActiveRecord::Base
  belongs_to :user
  belongs_to :category
end

class User < ActiveRecord::Base
  has_many :notes
end

class Category < ActiveRecord::Base
  has_many :notes
end

class CategorySerializer < Blueprinter::Base
  identifier :id
  fields :name, :created_at
end

class NoteSerializer < Blueprinter::Base
  identifier :id
  fields :name, :created_at
  association :category, blueprint: CategorySerializer
end

class UserSerializer < Blueprinter::Base
  identifier :id
  fields :name, :last_name, :email, :created_at
  association :notes, blueprint: NoteSerializer
end

class NoteContract < Dry::Validation::Contract
  params do
    required(:name).filled(:string)
  end
end

class UserContract < Dry::Validation::Contract
  params do
    required(:name).filled(:string)
    required(:last_name).filled(:string)
    required(:email).filled(:string)
  end
end

class CategoryContract < Dry::Validation::Contract
  params do
    required(:name).filled(:string)
  end
end

class App < Sinatra::Base
  include Pagy::Backend
  logger = Logger.new($stdout)

  register Sinatra::ActiveRecordExtension

  set :logger, logger
  set :database, { adapter: 'sqlite3', database: "#{environment}.sqlite3" }

  configure :development, :production do
    ActiveRecord::Base.logger = logger
  end

  configure :development do
    register Sinatra::Reloader
  end

  get '/' do
    status 200
  end

  get '/notes' do
    pagy, notes = pagy(Note.all, items: params[:size])
    json NoteSerializer.render_as_hash(notes, meta: pagy_metadata(pagy), root: :notes)
  end

  get '/notes/:id' do
    note = Note.find_by(id: params[:id])
    halt 404 if note.nil?
    json NoteSerializer.render_as_hash(note, root: :note)
  end

  post '/notes' do
    contract = NoteContract.new.call(params)
    halt 422, (json errors: contract.errors.to_h) if contract.failure?
    note = Note.create!(contract.to_h)
    status 201
    json NoteSerializer.render_as_hash(note, root: :note)
  end

  put '/notes/:id' do
    note = Note.find_by(id: params[:id])
    halt 404 if note.nil?
    contract = NoteContract.new.call(params)
    halt 422, (json errors: contract.errors.to_h) if contract.failure?
    note.update!(contract.to_h)
    json NoteSerializer.render_as_hash(note, root: :note)
  end

  delete '/notes/:id' do
    Note.find_by(id: params[:id])&.destroy!
    halt 204
  end

  get '/users' do
    pagy, users = pagy(User.all, items: params[:size])
    json UserSerializer.render_as_hash(users, meta: pagy_metadata(pagy), root: :users)
  end

  get '/users/:id' do
    user = User.find_by(id: params[:id])
    halt 404 if user.nil?
    json UserSerializer.render_as_hash(user, root: :user)
  end

  post '/users' do
    contract = UserContract.new.call(params)
    halt 422, (json errors: contract.errors.to_h) if contract.failure?
    user = User.create!(contract.to_h)
    status 201
    json UserSerializer.render_as_hash(user, root: :user)
  end

  put '/users/:id' do
    user = User.find_by(id: params[:id])
    halt 404 if user.nil?
    contract = UserContract.new.call(params)
    halt 422, (json errors: contract.errors.to_h) if contract.failure?
    user.update!(contract.to_h)
    json UserSerializer.render_as_hash(user, root: :user)
  end

  delete '/users/:id' do
    User.find_by(id: params[:id])&.destroy!
    halt 204
  end

  get '/categories' do
    pagy, categories = pagy(Category.all, items: params[:size])
    json CategorySerializer.render_as_hash(categories, meta: pagy_metadata(pagy), root: :categories)
  end

  get '/categories/:id' do
    category = Category.find_by(id: params[:id])
    halt 404 if category.nil?
    json CategorySerializer.render_as_hash(category, root: :category)
  end

  post '/categories' do
    contract = CategoryContract.new.call(params)
    halt 422, (json errors: contract.errors.to_h) if contract.failure?
    category = Category.create!(contract.to_h)
    status 201
    json CategorySerializer.render_as_hash(category, root: :category)
  end

  put '/categories/:id' do
    category = Category.find_by(id: params[:id])
    halt 404 if category.nil?
    contract = CategoryContract.new.call(params)
    halt 422, (json errors: contract.errors.to_h) if contract.failure?
    category.update!(contract.to_h)
    json CategorySerializer.render_as_hash(category, root: :category)
  end

  delete '/categories/:id' do
    Category.find_by(id: params[:id])&.destroy!
    halt 204
  end

  get '/users/:user_id/notes' do
    pagy, notes = pagy(Note.where(user_id: params[:user_id]), items: params[:size])
    json NoteSerializer.render_as_hash(notes, meta: pagy_metadata(pagy), root: :notes)
  end

  get '/categories/:category_id/notes' do
    pagy, notes = pagy(Note.where(category_id: params[:category_id]), items: params[:size])
    json NoteSerializer.render_as_hash(notes, meta: pagy_metadata(pagy), root: :notes)
  end
end
