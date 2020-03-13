# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Queries::OrganizationQuery, type: :request do
  let(:organization) { create(:organization, :complete) }
  let!(:opening_hour) { create(:organization_opening_hour, organization: organization) }

  describe '.resolve' do
    let(:data) { JSON.parse(response.body)['data']['organization'] }
    let(:attributes) do
      {
        'id' => organization.id,
        'name' => organization.name,
        'slug' => organization.slug,
        'countryCode' => organization.country_code,
        'url' => organization.url,
        'chatUrl' => organization.chat_url,
        'phoneWord' => organization.phone_word,
        'phoneNumber' => organization.phone_number,
        'smsWord' => organization.sms_word,
        'smsNumber' => organization.sms_number,
        'region' => organization.region,
        'categoryList' => match_array(organization.category_list),
        'humanSupportTypeList' => match_array(organization.human_support_type_list),
        'issueList' => match_array(organization.issue_list),
        'openingHours' => [{
          'id' => opening_hour.id,
          'timezone' => opening_hour.timezone,
          'open' => opening_hour.open.iso8601,
          'close' => opening_hour.close.iso8601,
          'day' => opening_hour.day
        }]
      }
    end

    it 'returns organization for provided slug' do
      post '/graphql', params: { query: query(slug: organization.slug) }
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
          countryCode
          url
          chatUrl
          region
          phoneWord
          phoneNumber
          smsWord
          smsNumber
          categoryList
          humanSupportTypeList
          issueList
          openingHours {
            id
            timezone
            open
            close
            day
          }
        }
      }
    GQL
  end
end
