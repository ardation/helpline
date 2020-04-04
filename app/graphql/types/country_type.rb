# frozen_string_literal: true

module Types
  class CountryType < BaseObject
    field :id, ID, null: false
    field :code, String, null: false
    field :name, String, null: false
    field :emergency_number, String, null: true
    field :subdivisions, [Types::Country::SubdivisionType], null: false
  end
end
