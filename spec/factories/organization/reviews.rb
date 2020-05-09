# frozen_string_literal: true

FactoryBot.define do
  factory :organization_review, class: 'Organization::Review' do
    rating { rand(0..5) }
    response_time { rand(0..30) }
    organization
    recaptcha_token { 'abc' }
    remote_ip { '127.0.0.1' }
  end
end
