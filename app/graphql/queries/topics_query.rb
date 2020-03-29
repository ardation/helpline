# frozen_string_literal: true

module Queries
  class TopicsQuery < BaseQuery
    description 'Find all topics'

    type [Types::TagType], null: false

    def resolve
      Organization.topic_counts.order(:name)
    end
  end
end
