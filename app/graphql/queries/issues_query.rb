# frozen_string_literal: true

module Queries
  class IssuesQuery < BaseQuery
    description 'Find all issues'

    type [Types::TagType], null: false

    def resolve
      Organization.issue_counts.order(:name)
    end
  end
end
