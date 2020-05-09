# frozen_string_literal: true

module Types
  module Organization
    class OpeningHourType < Types::BaseRecord
      field :day, String, null: false
      field :open, GraphQL::Types::ISO8601DateTime, null: false
      field :close, GraphQL::Types::ISO8601DateTime, null: false
    end
  end
end
