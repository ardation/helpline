# frozen_string_literal: true

module Queries
  class InfluencerQuery < BaseQuery
    description 'Find a influencer by slug'

    argument :slug, String, required: true

    type Types::InfluencerType, null: false

    def resolve(slug:)
      Influencer.find_by(slug: slug)
    end
  end
end
