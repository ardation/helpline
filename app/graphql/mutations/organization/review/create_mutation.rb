# frozen_string_literal: true

module Mutations
  module Organization
    module Review
      class CreateMutation < Mutations::BaseMutation
        graphql_name 'OrganizationReviewCreateMutation'
        argument :organization_id, ID, required: true
        argument :rating, Int, required: true
        argument :response_time, Int, required: true
        argument :content, String, required: false
        argument :recaptcha_token, String, required: true

        field :review, Types::Organization::ReviewType, null: true
        field :errors, [String], null: false

        def resolve(**attributes)
          review = ::Organization::Review.new(attributes.merge(remote_ip: context[:remote_ip]))

          review.save ? { review: review, errors: [] } : { review: nil, errors: review.errors.full_messages }
        end
      end
    end
  end
end
