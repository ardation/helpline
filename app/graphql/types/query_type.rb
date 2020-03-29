# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    field :categories, resolver: Queries::CategoriesQuery
    field :country, resolver: Queries::CountryQuery
    field :countries, resolver: Queries::CountriesQuery
    field :human_support_types, resolver: Queries::HumanSupportTypesQuery
    field :issues, resolver: Queries::IssuesQuery
    field :organization, resolver: Queries::OrganizationQuery
    field :organizations, resolver: Queries::OrganizationsQuery
  end
end
