# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Queries::CategoriesQuery, type: :query do
  before do
    create(:organization, category_list: ['category_def'])
    create(:organization, category_list: ['category_abc'])
  end

  let(:data) { { 'categories' => [{ 'name' => 'category_abc' }, { 'name' => 'category_def' }] } }

  it 'returns categories' do
    resolve(query)
    expect(response_data).to eq(data), invalid_response_data
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
