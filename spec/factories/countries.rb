# frozen_string_literal: true

FactoryBot.define do
  factory :country do
    code { ISO3166::Country.all.map(&:alpha2).sample }
    trait :complete do
      code { 'US' }
      after(:build) do |country|
        if country.subdivisions.empty?
          country.subdivisions.build(code: 'AL')
          country.subdivisions.build(code: 'FL')
        end
      end
    end
  end
end
