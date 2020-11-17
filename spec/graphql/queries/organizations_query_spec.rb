# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Queries::OrganizationsQuery, type: :query do
  let!(:organization0) do
    create(
      :organization,
      country: create(:country, code: 'AU'),
      category_list: ['category_0'],
      human_support_type_list: ['human_support_type_0'],
      topic_list: ['topic_0'],
      featured: true,
      verified: true
    )
  end
  let(:country_nz) { create(:country, code: 'NZ') }
  let!(:organization1) do
    create(
      :organization,
      country: country_nz,
      category_list: ['category_1'],
      human_support_type_list: ['human_support_type_1'],
      topic_list: ['topic_1']
    )
  end
  let!(:organization2) do
    create(
      :organization,
      country: country_nz,
      subdivisions: [create(:country_subdivision, country: country_nz, code: 'AUK')],
      category_list: ['category_1'],
      human_support_type_list: ['human_support_type_1'],
      topic_list: ['topic_1']
    )
  end
  let(:ids) { response_data['organizations']['nodes'].map { |organization| organization['id'] } }

  it 'returns organizations' do
    resolve(query)
    expect(ids).to match_array [organization0.id, organization1.id, organization2.id]
  end

  it 'returns organizations filtered by country_code' do
    resolve(query('countryCode: "AU"'))
    expect(ids).to match_array [organization0.id]
  end

  it 'returns organizations filtered by subdivison_codes' do
    resolve(query('subdivisionCodes: ["AUK"]'))
    expect(ids).to match_array [organization2.id]
  end

  it 'returns organizations filtered by empty subdivison_codes' do
    resolve(query('countryCode: "NZ", subdivisionCodes: []'))
    expect(ids).to match_array [organization1.id]
  end

  it 'returns organizations filtered by null subdivison_code and AUK' do
    resolve(query('countryCode: "NZ", subdivisionCodes: [null, "AUK"]'))
    expect(ids).to match_array [organization1.id, organization2.id]
  end

  it 'returns organizations filtered by categories' do
    resolve(query('categories: ["category_0"]'))
    expect(ids).to match_array [organization0.id]
  end

  it 'returns organizations filtered by human_support_type' do
    resolve(query('humanSupportTypes: ["human_support_type_0"]'))
    expect(ids).to match_array [organization0.id]
  end

  it 'returns organizations filtered by topics' do
    resolve(query('topics: ["topic_0"]'))
    expect(ids).to match_array [organization0.id]
  end

  it 'returns organizations filtered by featured' do
    resolve(query('featured: true'))
    expect(ids).to match_array [organization0.id]
  end

  it 'returns organizations filtered by verified' do
    resolve(query('verified: true'))
    expect(ids).to match_array [organization0.id]
  end

  def query(filter = '')
    <<~GQL
      query {
        organizations#{filter.present? ? "(#{filter})" : ''} {
          nodes {
            id
          }
        }
      }
    GQL
  end
end
