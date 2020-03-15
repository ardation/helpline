# frozen_string_literal: true

module Queries
  class CategoriesQuery < BaseQuery
    description 'Find all categories'

    type [Types::TagType], null: false

    def resolve
      Organization.category_counts.order(:name)
    end
  end
end
