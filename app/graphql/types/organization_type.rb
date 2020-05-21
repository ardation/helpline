# frozen_string_literal: true

module Types
  class OrganizationType < Types::BaseRecord
    field :name, String, null: false
    field :slug, String, null: false
    field :country, Types::CountryType, null: false
    field :categories, [Types::TagType], null: false
    field :chat_url, String, null: true
    field :human_support_types, [Types::TagType], null: false
    field :topics, [Types::TagType], null: false
    field :phone_number, String, null: true
    field :phone_word, String, null: true
    field :sms_number, String, null: true
    field :sms_word, String, null: true
    field :timezone, String, null: false
    field :url, String, null: true
    field :opening_hours, [Types::Organization::OpeningHourType], null: false
    field :reviews, [Types::Organization::ReviewType], null: false
    field :subdivisions, [Types::Country::SubdivisionType], null: false
    field :always_open, Boolean, null: false
    field :featured, Boolean, null: false
    field :verified, Boolean, null: false
    field :review_count, Integer, null: false
    field :rating, Float, null: false
    field :notes, String, null: true

    def categories
      Loaders::AssociationLoader.for(::Organization, :categories).load(object)
    end

    def human_support_types
      Loaders::AssociationLoader.for(::Organization, :human_support_types).load(object)
    end

    def topics
      Loaders::AssociationLoader.for(::Organization, :topics).load(object)
    end

    def opening_hours
      Loaders::AssociationLoader.for(::Organization, :opening_hours).load(object)
    end

    def subdivisions
      Loaders::AssociationLoader.for(::Organization, :subdivisions).load(object)
    end

    def timezone
      ActiveSupport::TimeZone[object.timezone].tzinfo.name
    end

    def reviews
      Loaders::AssociationLoader.for(::Organization, :published_reviews).load(object)
    end
  end
end
