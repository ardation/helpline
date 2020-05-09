# frozen_string_literal: true

module Types
  class CountryType < Types::BaseRecord
    field :code, String, null: false
    field :name, String, null: false
    field :emergency_number, String, null: true
    field :subdivisions, [Types::Country::SubdivisionType], null: false
  end
end
