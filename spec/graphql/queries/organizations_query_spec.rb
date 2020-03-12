# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Queries::OrganizationsQuery, type: :request do
  let!(:organization_0) { create(:organization) }
  let!(:organization_1) { create(:organization) }

  describe '.resolve' do
    let(:data) { JSON.parse(response.body)['data']['organizations'] }
    let(:attributes_0) do
      {
        'id' => organization_0.id,
        'name' => organization_0.name,
        'slug' => organization_0.slug
      }
    end
    let(:attributes_1) do
      {
        'id' => organization_1.id,
        'name' => organization_1.name,
        'slug' => organization_1.slug
      }
    end

    it 'returns organizations' do
      post '/graphql', params: { query: query }

      expect(data).to match_array [
        hash_including(attributes_0),
        hash_including(attributes_1)
      ]
    end
  end

  def query
    <<~GQL
      query {
        organizations {
          id
          name
          slug
        }
      }
    GQL
  end
end
