# frozen_string_literal: true

module Types
  module Organization
    class ReviewType < Types::BaseRecord
      field :rating, Int, null: false
      field :content, String, null: true
    end
  end
end
