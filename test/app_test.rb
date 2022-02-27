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

  def test_get_users_with_pagination
    create_list(:user, 20)
    get '/users', page: 1, size: 10
    response = JSON.parse(last_response.body)
    assert_equal(10, response['users'].length)
  end

  def test_get_category
    category = create(:category)
    get "/categories/#{category.id}"
    response = JSON.parse(last_response.body)
    assert_equal(category.id, response['category']['id'])
  end

  def test_get_categories_with_pagination
    create_list(:category, 20)
    get '/categories', page: 1, size: 3
    response = JSON.parse(last_response.body)
    assert_equal(3, response['categories'].length)
  end
end
