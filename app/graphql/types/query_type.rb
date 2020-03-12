# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    field :organization, resolver: Queries::OrganizationQuery
    field :organizations, resolver: Queries::OrganizationsQuery
  end
end
