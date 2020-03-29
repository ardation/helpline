# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Queries::CountriesQuery, type: :request do
  before { host! 'api.example.com' }

  let!(:country_0) { create(:country, code: 'NZ') }
  let!(:country_1) { create(:country, code: 'AU') }

  describe '.resolve' do
    let(:data) { JSON.parse(response.body)['data']['countries'] }
    let(:attributes_0) { { 'id' => country_0.id, 'name' => 'New Zealand' } }
    let(:attributes_1) { { 'id' => country_1.id, 'name' => 'Australia' } }

    it 'returns countries' do
      post '/', params: { query: query }

      expect(data).to eq [attributes_1, attributes_0]
    end
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
