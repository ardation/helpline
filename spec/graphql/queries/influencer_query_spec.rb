# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Queries::InfluencerQuery, type: :request do
  before { host! 'api.example.com' }

  let(:influencer) { create(:influencer) }

  describe '.resolve' do
    let(:data) { JSON.parse(response.body)['data']['influencer'] }
    let(:attributes) do
      {
        'id' => influencer.id,
        'name' => influencer.name,
        'message' => influencer.message
      }
    end

    it 'returns influencer for provided slug' do
      post '/', params: { query: query(slug: influencer.slug) }
      expect(data).to include(attributes)
    end
  end

  def query(slug:)
    <<~GQL
      query {
        influencer(slug: "#{slug}") {
          id
          name
          message
        }
      }
    GQL
  end
end
