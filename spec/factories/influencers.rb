# frozen_string_literal: true

FactoryBot.define do
  factory :influencer do
    name { Faker::Name.name }
    slug { Faker::Internet.slug }
    message { Faker::Lorem.paragraph }
  end
end
