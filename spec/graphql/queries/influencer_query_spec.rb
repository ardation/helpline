# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Queries::InfluencerQuery, type: :query do
  let(:influencer) { create(:influencer) }
  let(:data) do
    { 'influencer' => {
      'id' => influencer.id,
      'name' => influencer.name,
      'message' => influencer.message
    } }
  end

  it 'returns influencer' do
    resolve(query(slug: influencer.slug))
    expect(response_data).to eq(data), invalid_response_data
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
