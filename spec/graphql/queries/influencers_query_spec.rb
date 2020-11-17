# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Queries::InfluencersQuery, type: :query do
  let!(:influencer) { create(:influencer) }

  let(:data) do
    { 'influencers' => [{ 'name' => influencer.name, 'slug' => influencer.slug, 'message' => influencer.message }] }
  end

  it 'returns influencers' do
    resolve(query)
    expect(response_data).to eq(data), invalid_response_data
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
