# frozen_string_literal: true

module Types
  module Country
    class SubdivisionType < BaseObject
      field :id, ID, null: false
      field :code, String, null: false
      field :name, String, null: false
      field :country, Types::CountryType, null: false
    end
  end
end
