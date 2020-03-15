# frozen_string_literal: true

module Queries
  class HumanSupportTypesQuery < BaseQuery
    description 'Find all humanSupportTypes'

    type [Types::TagType], null: false

    def resolve
      Organization.human_support_type_counts
    end
  end
end
