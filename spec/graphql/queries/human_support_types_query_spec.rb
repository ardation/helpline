# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Queries::HumanSupportTypesQuery, type: :request do
  before do
    create(:organization, human_support_type_list: ['human_support_type_0'])
    create(:organization, human_support_type_list: ['human_support_type_1'])
  end

  describe '.resolve' do
    let(:data) { JSON.parse(response.body)['data']['humanSupportTypes'] }

    it 'returns human_support_types' do
      post '/graphql', params: { query: query }

      expect(data).to match_array [{ 'name' => 'human_support_type_0' }, { 'name' => 'human_support_type_1' }]
    end
  end

  def query
    <<~GQL
      query {
        humanSupportTypes {
          name
        }
      }
    GQL
  end
end
