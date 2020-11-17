# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Queries::CountryQuery, type: :query do
  let(:country) { create(:country, :complete) }
  let(:data) do
    {
      'country' => {
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
    }
  end

  it 'returns categories' do
    resolve(query(code: country.code))
    expect(response_data).to include(data), invalid_response_data
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
