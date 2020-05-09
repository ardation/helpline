# frozen_string_literal: true

module Types
  module Country
    class SubdivisionType < Types::BaseRecord
      field :code, String, null: false
      field :name, String, null: false
      field :country, Types::CountryType, null: false
    end
  end
end
