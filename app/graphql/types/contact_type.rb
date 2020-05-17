# frozen_string_literal: true

module Types
  class ContactType < Types::BaseRecord
    field :email, String, null: false
    field :subject, String, null: false
    field :message, String, null: false
  end
end
