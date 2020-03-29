# frozen_string_literal: true

module Queries
  class OrganizationsQuery < BaseQuery
    description 'Find all organizations'

    argument :country_code, String, required: false, description: 'Filter by countryCode'
    argument :categories, [String], required: false, description: 'Filter by categories'
    argument :human_support_types, [String], required: false, description: 'Filter by humanSupportTypes'
    argument :topics, [String], required: false, description: 'Filter by topics'

    type Types::OrganizationType.connection_type, null: false

    def resolve(country_code: nil, categories: [], human_support_types: [], topics: [])
      organizations = Organization.all
      organizations = organizations.joins(:country).where(countries: { code: country_code }) if country_code
      organizations = organizations.tagged_with(categories, on: :categories) unless categories.empty?
      unless human_support_types.empty?
        organizations = organizations.tagged_with(human_support_types, on: :human_support_types)
      end
      organizations = organizations.tagged_with(topics, on: :topics) unless topics.empty?
      organizations
    end
  end
end
