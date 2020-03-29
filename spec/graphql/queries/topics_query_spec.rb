# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Queries::TopicsQuery, type: :request do
  before do
    host! 'api.example.com'
    create(:organization, topic_list: ['topic_def'])
    create(:organization, topic_list: ['topic_abc'])
  end

  describe '.resolve' do
    let(:data) { JSON.parse(response.body)['data']['topics'] }

    it 'returns topics' do
      post '/', params: { query: query }

      expect(data).to eq [{ 'name' => 'topic_abc' }, { 'name' => 'topic_def' }]
    end
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
