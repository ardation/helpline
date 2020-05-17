# frozen_string_literal: true

FactoryBot.define do
  factory :contact do
    email { Faker::Internet.email }
    subject { Faker::Lorem.question }
    message { Faker::Lorem.paragraph }
    recaptcha_token { 'abc' }
    remote_ip { '127.0.0.1' }
  end
end
