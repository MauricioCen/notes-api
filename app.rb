# frozen_string_literal: true

require 'sinatra/base'

class App < Sinatra::Base
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
