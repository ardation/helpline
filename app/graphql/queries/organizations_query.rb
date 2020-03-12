# frozen_string_literal: true

module Queries
  class OrganizationsQuery < BaseQuery
    description 'Find all organizations'

    type [Types::OrganizationType], null: false

    def resolve
      Organization.all
    end
  end
end
