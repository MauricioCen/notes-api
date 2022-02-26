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
end
