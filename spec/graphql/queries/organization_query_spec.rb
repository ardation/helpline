# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Queries::OrganizationQuery, type: :query do
  let(:organization) { create(:organization, :complete, featured: true, verified: true) }
  let(:data) do
    { 'organization' => {
      'id' => organization.id,
      'name' => organization.name,
      'slug' => organization.slug,
      'country' => {
        'code' => organization.country.code
      },
      'url' => organization.url,
      'chatUrl' => organization.chat_url,
      'phoneWord' => organization.phone_word,
      'phoneNumber' => organization.phone_number,
      'smsWord' => organization.sms_word,
      'smsNumber' => organization.sms_number,
      'timezone' => ActiveSupport::TimeZone[organization.timezone].tzinfo.name,
      'alwaysOpen' => organization.always_open,
      'featured' => organization.featured,
      'verified' => organization.verified,
      'rating' => organization.rating,
      'reviewCount' => organization.review_count,
      'notes' => organization.notes,
      'subdivisions' =>
        match_array(organization.subdivisions.map { |t| { 'code' => t.code } }),
      'categories' =>
        match_array(organization.categories.map { |t| { 'name' => t.name } }),
      'humanSupportTypes' =>
        match_array(organization.human_support_types.map { |t| { 'name' => t.name } }),
      'topics' =>
        match_array(organization.topics.map { |t| { 'name' => t.name } }),
      'openingHours' => [{
        'id' => opening_hour2.id,
        'open' => opening_hour2.open.iso8601,
        'close' => opening_hour2.close.iso8601,
        'day' => opening_hour2.day
      }, {
        'id' => opening_hour1.id,
        'open' => opening_hour1.open.iso8601,
        'close' => opening_hour1.close.iso8601,
        'day' => opening_hour1.day
      }, {
        'id' => opening_hour0.id,
        'open' => opening_hour0.open.iso8601,
        'close' => opening_hour0.close.iso8601,
        'day' => opening_hour0.day
      }],
      'reviews' => [{
        'id' => organization.reviews.published.first.id,
        'rating' => organization.reviews.published.first.rating,
        'content' => organization.reviews.published.first.content
      }]
    } }
  end
  let!(:opening_hour0) do
    create(
      :organization_opening_hour,
      organization: organization,
      day: 'tuesday'
    )
  end
  let!(:opening_hour1) do
    create(
      :organization_opening_hour,
      organization: organization,
      day: 'monday',
      open: Time.current.beginning_of_day + 4.hours,
      close: Time.current.beginning_of_day + 5.hours
    )
  end
  let!(:opening_hour2) do
    create(
      :organization_opening_hour,
      organization: organization,
      day: 'monday',
      open: Time.current.beginning_of_day + 2.hours,
      close: Time.current.beginning_of_day + 3.hours
    )
  end

  before do
    create(:organization_review, organization: organization, published: true)
    create(:organization_review, organization: organization)
    organization.update_review_statistics
  end

  it 'returns organization' do
    resolve(query(slug: organization.slug))
    expect(response_data).to include(data), invalid_response_data
  end

  def query(slug:)
    <<~GQL
      query {
        organization(slug: "#{slug}") {
          id
          name
          slug
          url
          chatUrl
          phoneWord
          phoneNumber
          smsWord
          smsNumber
          timezone
          alwaysOpen
          featured
          verified
          rating
          reviewCount
          notes
          country {
            code
          }
          subdivisions {
            code
          }
          categories {
            name
          }
          humanSupportTypes {
            name
          }
          topics {
            name
          }
          openingHours {
            id
            open
            close
            day
          }
          reviews {
            id
            rating
            content
           }
        }
      }
    GQL
  end
end
