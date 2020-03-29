# frozen_string_literal: true

module Queries
  class CountriesQuery < BaseQuery
    description 'Find all countries'

    type [Types::CountryType], null: false

    def resolve
      Country.order(code: :asc).all
    end
  end
end
