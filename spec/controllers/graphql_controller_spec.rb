# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GraphqlController, type: :controller do
  before do
    create(:organization, category_list: ['category_def'])
    create(:organization, category_list: ['category_abc'])
  end

  describe '.execute' do
    let(:data) { JSON.parse(response.body)['data']['categories'] }

    it 'returns categories' do
      post :execute, params: { query: query }

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
