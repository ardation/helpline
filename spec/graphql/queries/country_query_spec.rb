# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Queries::CountryQuery, type: :request do
  before { host! 'api.example.com' }

  let(:country) { create(:country, :complete) }

  describe '.resolve' do
    let(:data) { JSON.parse(response.body)['data']['country'] }
    let(:attributes) do
      {
        'id' => country.id,
        'name' => country.name,
        'emergencyNumber' => country.emergency_number,
        'subdivisions' => match_array(country.subdivisions.map do |t|
          {
            'id' => t.id,
            'code' => t.code,
            'name' => t.name
          }
        end)
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
          subdivisions {
            id
            code
            name
          }
        }
      }
    GQL
  end
end
