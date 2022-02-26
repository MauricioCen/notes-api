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

  def test_create_note
    note = create(:note)
    assert_equal(note.persisted?, true)
  end
end
