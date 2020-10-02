# frozen_string_literal: true

module Queries
  class InfluencersQuery < BaseQuery
    description 'Find all influencers'

    type [Types::InfluencerType], null: false

    def resolve
      Influencer.all
    end
  end
end
