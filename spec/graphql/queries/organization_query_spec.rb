# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Queries::OrganizationQuery, type: :request do
  let(:organization) { create(:organization) }

  describe '.resolve' do
    let(:data) { JSON.parse(response.body)['data']['organization'] }
    let(:attributes) do
      {
        'id' => organization.id,
        'name' => organization.name,
        'slug' => organization.slug
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
        }
      }
    GQL
  end
end
