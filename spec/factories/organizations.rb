# frozen_string_literal: true

FactoryBot.define do
  factory :organization do
    name { Faker::Name.name }
    country
    timezone { ActiveSupport::TimeZone.all.map(&:name).sample }
    trait :complete do
      association :country, factory: :country, code: 'US'
      category_list { Faker::Lorem.words(number: 4) }
      chat_url { Faker::Internet.url }
      human_support_type_list { Faker::Lorem.words(number: 4) }
      topic_list { Faker::Lorem.words(number: 4) }
      phone_number { Faker::PhoneNumber.phone_number }
      phone_word { Faker::PhoneNumber.phone_number }
      sms_number { Faker::PhoneNumber.phone_number }
      sms_word { Faker::Lorem.word }
      url { Faker::Internet.url }
      notes { Faker::Lorem.paragraph }
      after(:build) do |organization|
        if organization.subdivisions.empty?
          organization.subdivisions.build(code: 'AL', country: organization.country)
          organization.subdivisions.build(code: 'FL', country: organization.country)
        end
      end
    end
  end
end
