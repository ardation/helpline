# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Queries::HumanSupportTypesQuery, type: :query do
  before do
    create(:organization, human_support_type_list: ['human_support_type_def'])
    create(:organization, human_support_type_list: ['human_support_type_abc'])
  end

  let(:data) do
    { 'humanSupportTypes' => [{ 'name' => 'human_support_type_abc' }, { 'name' => 'human_support_type_def' }] }
  end

  it 'returns humanSupportTypes' do
    resolve(query)
    expect(response_data).to eq(data), invalid_response_data
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
