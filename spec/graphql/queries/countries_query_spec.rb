# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Queries::CountriesQuery, type: :query do
  let!(:country0) { create(:country, code: 'NZ') }
  let!(:country1) { create(:country, code: 'AU') }
  let(:data) do
    {
      'countries' => [
        { 'id' => country1.id, 'name' => 'Australia' },
        { 'id' => country0.id, 'name' => 'New Zealand' }
      ]
    }
  end

  it 'returns countries' do
    resolve(query)
    expect(response_data).to eq(data), invalid_response_data
  end

  def query
    <<~GQL
      query {
        countries {
          id
          name
        }
      }
    GQL
  end
end
