# frozen_string_literal: true

FactoryBot.define do
  factory :country_subdivision, class: 'Country::Subdivision' do
    country { Country.find_by(code: 'US') || create(:country, code: 'US') }
    after(:build) do |subdivision|
      subdivision.code ||= subdivision.iso_3166_country&.subdivisions&.keys&.sample
    end
  end
end
