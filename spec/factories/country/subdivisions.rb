# frozen_string_literal: true

FactoryBot.define do
  factory :country_subdivision, class: 'Country::Subdivision' do
    association :country, factory: :country, code: 'US'
    after(:build) do |subdivision|
      subdivision.code ||= subdivision.country.iso_3166_country.subdivisions.keys.sample
    end
  end
end
