# frozen_string_literal: true

module Types
  class OrganizationType < BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :slug, String, null: false

    field :country_code, String, null: false
    field :category_list, [String], null: false
    field :chat_url, String, null: true
    field :human_support_type_list, [String], null: false
    field :issue_list, [String], null: false
    field :phone_number, String, null: true
    field :phone_word, String, null: true
    field :region, String, null: true
    field :sms_number, String, null: true
    field :sms_word, String, null: true
    field :url, String, null: true
    field :opening_hours, [Types::Organization::OpeningHourType], null: false
  end
end
