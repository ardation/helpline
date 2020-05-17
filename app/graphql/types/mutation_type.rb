# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    field :organization_review_create, resolver: Mutations::Organization::Review::CreateMutation
    field :contact_create, resolver: Mutations::Contact::CreateMutation
  end
end
