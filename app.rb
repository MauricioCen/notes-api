# frozen_string_literal: true

require 'sinatra'

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
  "create items"
end