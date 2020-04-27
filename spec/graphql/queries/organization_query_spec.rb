# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Queries::OrganizationQuery, type: :request do
  before { host! 'api.example.com' }

  let(:organization) { create(:organization, :complete, featured: true) }
  let!(:opening_hour) { create(:organization_opening_hour, organization: organization) }

  describe '.resolve' do
    let(:data) { JSON.parse(response.body)['data']['organization'] }
    let(:attributes) do
      {
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
        'subdivisions' =>
          match_array(organization.subdivisions.map { |t| { 'code' => t.code } }),
        'categories' =>
          match_array(organization.categories.map { |t| { 'name' => t.name } }),
        'humanSupportTypes' =>
          match_array(organization.human_support_types.map { |t| { 'name' => t.name } }),
        'topics' =>
          match_array(organization.topics.map { |t| { 'name' => t.name } }),
        'openingHours' => [{
          'id' => opening_hour.id,
          'open' => opening_hour.open.iso8601,
          'close' => opening_hour.close.iso8601,
          'day' => opening_hour.day
        }]
      }
    end

    it 'returns organization for provided slug' do
      post '/', params: { query: query(slug: organization.slug) }
      expect(data).to include(attributes)
    end
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
        }
      }
    GQL
  end
end
