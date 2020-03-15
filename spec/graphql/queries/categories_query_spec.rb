# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Queries::CategoriesQuery, type: :request do
  before do
    create(:organization, category_list: ['category_0'])
    create(:organization, category_list: ['category_1'])
  end

  describe '.resolve' do
    let(:data) { JSON.parse(response.body)['data']['categories'] }

    it 'returns categories' do
      post '/graphql', params: { query: query }

      expect(data).to match_array [{ 'name' => 'category_0' }, { 'name' => 'category_1' }]
    end
  end

  def query
    <<~GQL
      query {
        categories {
          name
        }
      }
    GQL
  end
end
