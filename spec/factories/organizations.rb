# frozen_string_literal: true

FactoryBot.define do
  factory :organization do
    name { Faker::Name.name }
    country_code { ISO3166::Country.all.map(&:alpha2).sample }
    timezone { ActiveSupport::TimeZone.all.map(&:name).sample }
    trait :complete do
      category_list { Faker::Lorem.words(number: 4) }
      chat_url { Faker::Internet.url }
      human_support_type_list { Faker::Lorem.words(number: 4) }
      issue_list { Faker::Lorem.words(number: 4) }
      phone_number { Faker::PhoneNumber.phone_number }
      phone_word { Faker::PhoneNumber.phone_number }
      sms_number { Faker::PhoneNumber.phone_number }
      sms_word { Faker::Lorem.word }
      region { Faker::Address.state }
      url { Faker::Internet.url }
    end
  end
end
