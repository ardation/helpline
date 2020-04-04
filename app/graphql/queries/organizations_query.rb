# frozen_string_literal: true

module Queries
  class OrganizationsQuery < BaseQuery
    description 'Find all organizations'

    argument :country_code, String, required: false, description: 'Filter by countryCode'
    argument :subdivision_codes, [String], required: false, description: 'Filter by subdivisionCodes'
    argument :categories, [String], required: false, description: 'Filter by categories'
    argument :human_support_types, [String], required: false, description: 'Filter by humanSupportTypes'
    argument :topics, [String], required: false, description: 'Filter by topics'

    type Types::OrganizationType.connection_type, null: false

    def resolve(**filters)
      Organization.filter(filters)
    end
  end
end
