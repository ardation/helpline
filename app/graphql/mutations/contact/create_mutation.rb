# frozen_string_literal: true

module Mutations
  module Contact
    class CreateMutation < Mutations::BaseMutation
      graphql_name 'ContactCreateMutation'
      argument :email, String, required: true
      argument :subject, String, required: true
      argument :message, String, required: true
      argument :recaptcha_token, String, required: true

      field :contact, Types::ContactType, null: true
      field :errors, [String], null: false

      def resolve(**attributes)
        contact = ::Contact.new(attributes.merge(remote_ip: context[:remote_ip]))

        contact.save ? { contact: contact, errors: [] } : { contact: nil, errors: contact.errors.full_messages }
      end
    end
  end
end
