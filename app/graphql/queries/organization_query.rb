# frozen_string_literal: true

module Queries
  class OrganizationQuery < BaseQuery
    description 'Find an organization by slug'

    argument :slug, String, required: true

    type Types::OrganizationType, null: false

    def resolve(slug:)
      Organization.friendly.find(slug)
    end
  end
end
