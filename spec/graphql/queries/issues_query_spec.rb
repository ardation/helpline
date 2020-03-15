# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Queries::IssuesQuery, type: :request do
  before do
    create(:organization, issue_list: ['issue_0'])
    create(:organization, issue_list: ['issue_1'])
  end

  describe '.resolve' do
    let(:data) { JSON.parse(response.body)['data']['issues'] }

    it 'returns issues' do
      post '/graphql', params: { query: query }

      expect(data).to match_array [{ 'name' => 'issue_0' }, { 'name' => 'issue_1' }]
    end
  end

  def query
    <<~GQL
      query {
        issues {
          name
        }
      }
    GQL
  end
end
