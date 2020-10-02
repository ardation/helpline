# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Queries::InfluencersQuery, type: :request do
  subject!(:influencer) { create(:influencer) }

  before do
    host! 'api.example.com'
  end

  describe '.resolve' do
    let(:data) { JSON.parse(response.body)['data']['influencers'] }

    it 'returns topics' do
      post '/', params: { query: query }

      expect(data).to eq [{ 'name' => influencer.name, 'slug' => influencer.slug, 'message' => influencer.message }]
    end
  end

  def query
    <<~GQL
      query {
        influencers {
          name
          slug
          message
        }
      }
    GQL
  end
end
