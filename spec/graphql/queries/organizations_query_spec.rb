# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Queries::OrganizationsQuery, type: :request do
  let!(:organization_0) { create(:organization, country_code: 'AU') }
  let!(:organization_1) { create(:organization, country_code: 'NZ') }

  describe '.resolve' do
    let(:data) { JSON.parse(response.body)['data']['organizations']['nodes'] }
    let(:attributes_0) do
      {
        'id' => organization_0.id,
        'name' => organization_0.name,
        'slug' => organization_0.slug,
        'countryCode' => organization_0.country_code
      }
    end
    let(:attributes_1) do
      {
        'id' => organization_1.id,
        'name' => organization_1.name,
        'slug' => organization_1.slug,
        'countryCode' => organization_1.country_code
      }
    end

    it 'returns organizations' do
      post '/graphql', params: { query: query }

      expect(data).to match_array [
        hash_including(attributes_0),
        hash_including(attributes_1)
      ]
    end

    it 'returns organizations filtered by country_code' do
      post '/graphql', params: { query: query_by_country_code('AU') }

      expect(data).to match_array [
        hash_including(attributes_0)
      ]
    end
  end

  def query
    <<~GQL
      query {
        organizations {
          nodes {
            id
            name
            slug
            countryCode
          }
        }
      }
    GQL
  end

  def query_by_country_code(country_code)
    <<~GQL
      query {
        organizations(countryCode: "#{country_code}") {
          nodes {
            id
            name
            slug
            countryCode
          }
        }
      }
    GQL
  end
end
