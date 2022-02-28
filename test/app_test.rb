# frozen_string_literal: true

ENV['RACK_ENV'] ||= 'test'

require_relative '../app'
require 'minitest/autorun'

FactoryBot.find_definitions
DatabaseCleaner.clean_with(:truncation)
DatabaseCleaner.strategy = :truncation

class AppTest < Minitest::Test
  include Rack::Test::Methods
  include FactoryBot::Syntax::Methods

  def app
    App
  end

  def setup
    DatabaseCleaner.start
  end

  def teardown
    DatabaseCleaner.clean
  end

  def test_get_note
    note = create(:note)
    get "/notes/#{note.id}"
    response = JSON.parse(last_response.body)
    assert_equal(note.id, response['note']['id'])
  end

  def test_get_note_with_fake_id
    get '/notes/fake_id'
    assert_equal(404, last_response.status)
  end

  def test_get_notes_with_pagination
    create_list(:note, 20)
    get '/notes', page: 1, size: 10
    response = JSON.parse(last_response.body)
    assert_equal(10, response['notes'].length)
  end

  def test_create_note
    payload = { name: FFaker::Lorem.word }
    post '/notes', payload
    response = JSON.parse(last_response.body)
    assert_equal(payload[:name], response['note']['name'])
  end

  def test_try_create_note_without_name
    post '/notes', name: ''
    assert_equal(422, last_response.status)
  end

  def test_delete_note
    note = create(:note)
    delete "/notes/#{note.id}"
    assert_equal(false, Note.exists?(note.id))
  end

  def test_update_note
    note = create(:note)
    new_name = FFaker::Lorem.word
    put "/notes/#{note.id}", name: new_name
    response = JSON.parse(last_response.body)
    assert_equal(new_name, response['note']['name'])
  end

  def test_get_user
    user = create(:user)
    get "/users/#{user.id}"
    response = JSON.parse(last_response.body)
    assert_equal(user.id, response['user']['id'])
  end

  def test_get_user_with_fake_id
    get '/users/fake_id'
    assert_equal(404, last_response.status)
  end

  def test_get_users_with_pagination
    create_list(:user, 20)
    get '/users', page: 1, size: 10
    response = JSON.parse(last_response.body)
    assert_equal(10, response['users'].length)
  end

  def test_create_user
    payload = { name: FFaker::Name.first_name, last_name: FFaker::Name.last_name, email: FFaker::Internet.email }
    post '/users', payload
    response = JSON.parse(last_response.body)['user']
    assert_equal(payload[:name], response['name'])
    assert_equal(payload[:last_name], response['last_name'])
    assert_equal(payload[:email], response['email'])
  end

  def test_try_create_user_without_name
    post '/users', name: ''
    assert_equal(422, last_response.status)
  end

  def test_delete_user
    user = create(:user)
    delete "/users/#{user.id}"
    assert_equal(false, User.exists?(user.id))
  end

  def test_update_user
    user = create(:user)
    new_name = FFaker::Name.first_name
    last_name = FFaker::Name.last_name
    email = FFaker::Internet.email
    put "/users/#{user.id}", name: new_name, last_name: last_name, email: email
    response = JSON.parse(last_response.body)['user']
    assert_equal(new_name, response['name'])
    assert_equal(last_name, response['last_name'])
    assert_equal(email, response['email'])
  end

  def test_get_category
    category = create(:category)
    get "/categories/#{category.id}"
    response = JSON.parse(last_response.body)
    assert_equal(category.id, response['category']['id'])
  end

  def test_get_category_with_fake_id
    get '/category/fake_id'
    assert_equal(404, last_response.status)
  end

  def test_get_categories_with_pagination
    create_list(:category, 20)
    get '/categories', page: 1, size: 3
    response = JSON.parse(last_response.body)
    assert_equal(3, response['categories'].length)
  end

  def test_create_category
    payload = { name: FFaker::Lorem.word }
    post '/categories', payload
    response = JSON.parse(last_response.body)
    assert_equal(payload[:name], response['category']['name'])
  end

  def test_try_create_category_without_name
    post '/categories', name: ''
    assert_equal(422, last_response.status)
  end

  def test_delete_category
    category = create(:category)
    delete "/categories/#{category.id}"
    assert_equal(false, Category.exists?(category.id))
  end

  def test_update_category
    category = create(:category)
    new_name = FFaker::Lorem.word
    put "/categories/#{category.id}", name: new_name
    response = JSON.parse(last_response.body)
    assert_equal(new_name, response['category']['name'])
  end
end
