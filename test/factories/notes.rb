# frozen_string_literal: true

FactoryBot.define do
  factory :note do
    name { FFaker::Lorem.word }
  end
end
