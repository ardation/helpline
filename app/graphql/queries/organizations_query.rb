# frozen_string_literal: true

module Queries
  class OrganizationsQuery < BaseQuery
    description 'Find all organizations'

    argument :country_code, String, required: false

    type Types::OrganizationType.connection_type, null: false

    def resolve(country_code: nil)
      organizations = Organization.all
      organizations = organizations.where(country_code: country_code) if country_code

      organizations
    end
  end
end
