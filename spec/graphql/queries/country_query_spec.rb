# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Queries::CountryQuery, type: :request do
  before { host! 'api.example.com' }

  let(:country) { create(:country) }

  describe '.resolve' do
    let(:data) { JSON.parse(response.body)['data']['country'] }
    let(:attributes) do
      {
        'id' => country.id,
        'name' => country.name,
        'emergencyNumber' => country.emergency_number
      }
    end

    it 'returns country for provided code' do
      post '/', params: { query: query(code: country.code) }
      expect(data).to include(attributes)
    end
  end

  def query(code:)
    <<~GQL
      query {
        country(code: "#{code}") {
          id
          name
          emergencyNumber
        }
      }
    GQL
  end
end
