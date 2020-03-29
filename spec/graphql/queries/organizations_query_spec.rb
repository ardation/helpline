# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Queries::OrganizationsQuery, type: :request do
  before { host! 'api.example.com' }

  let!(:organization_0) do
    create(
      :organization,
      country: create(:country, code: 'AU'),
      category_list: ['category_0'],
      human_support_type_list: ['human_support_type_0'],
      topic_list: ['topic_0']
    )
  end
  let!(:organization_1) do
    create(
      :organization,
      country: create(:country, code: 'NZ'),
      category_list: ['category_1'],
      human_support_type_list: ['human_support_type_1'],
      topic_list: ['topic_1']
    )
  end

  describe '.resolve' do
    let(:data) { JSON.parse(response.body)['data']['organizations']['nodes'] }
    let(:attributes_0) { { 'id' => organization_0.id } }
    let(:attributes_1) { { 'id' => organization_1.id } }

    it 'returns organizations' do
      post '/', params: { query: query }

      expect(data).to match_array [
        hash_including(attributes_0),
        hash_including(attributes_1)
      ]
    end

    it 'returns organizations filtered by country_code' do
      post '/', params: { query: query('(countryCode: "AU")') }

      expect(data).to match_array [
        hash_including(attributes_0)
      ]
    end

    it 'returns organizations filtered by categories' do
      post '/', params: { query: query('(categories: ["category_0"])') }

      expect(data).to match_array [
        hash_including(attributes_0)
      ]
    end

    it 'returns organizations filtered by human_support_type' do
      post '/', params: { query: query('(humanSupportTypes: ["human_support_type_0"])') }

      expect(data).to match_array [
        hash_including(attributes_0)
      ]
    end

    it 'returns organizations filtered by topics' do
      post '/', params: { query: query('(topics: ["topic_0"])') }

      expect(data).to match_array [
        hash_including(attributes_0)
      ]
    end
  end

  def query(filter = '')
    <<~GQL
      query {
        organizations#{filter} {
          nodes {
            id
          }
        }
      }
    GQL
  end
end
