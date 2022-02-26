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

  def test_get_notes_with_pagination
    create_list(:note, 20)
    get '/notes', page: 1, size: 10
    response = JSON.parse(last_response.body)
    assert_equal(10, response['notes'].length)
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
