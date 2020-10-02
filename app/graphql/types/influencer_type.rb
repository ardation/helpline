# frozen_string_literal: true

module Types
  class InfluencerType < Types::BaseRecord
    field :name, String, null: false
    field :slug, String, null: false
    field :message, String, null: false
  end
end
