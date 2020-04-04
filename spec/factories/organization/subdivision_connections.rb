# frozen_string_literal: true

FactoryBot.define do
  factory :organization_subdivision_connection, class: 'Organization::SubdivisionConnection' do
    organization
    association :subdivision, factory: :country_subdivision
  end
end
