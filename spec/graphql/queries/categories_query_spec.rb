# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Queries::CategoriesQuery, type: :request do
  before do
    host! 'api.example.com'
    create(:organization, category_list: ['category_def'])
    create(:organization, category_list: ['category_abc'])
  end

  describe '.resolve' do
    let(:data) { JSON.parse(response.body)['data']['categories'] }

    it 'returns categories' do
      post '/', params: { query: query }

      expect(data).to eq [{ 'name' => 'category_abc' }, { 'name' => 'category_def' }]
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
