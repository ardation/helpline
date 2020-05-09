# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    field :organization_review_create, resolver: Mutations::Organization::Review::CreateMutation
  end
end
