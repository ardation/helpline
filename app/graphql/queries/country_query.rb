# frozen_string_literal: true

module Queries
  class CountryQuery < BaseQuery
    description 'Find a country by code'

    argument :code, String, required: true

    type Types::CountryType, null: false

    def resolve(code:)
      Country.find_by(code: code.upcase)
    end
  end
end
