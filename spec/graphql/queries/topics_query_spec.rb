# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Queries::TopicsQuery, type: :query do
  before do
    create(:organization, topic_list: ['topic_def'])
    create(:organization, topic_list: ['topic_abc'])
  end

  let(:data) { { 'topics' => [{ 'name' => 'topic_abc' }, { 'name' => 'topic_def' }] } }

  it 'returns topics' do
    resolve(query)
    expect(response_data).to eq(data), invalid_response_data
  end

  def query
    <<~GQL
      query {
        topics {
          name
        }
      }
    GQL
  end
end
