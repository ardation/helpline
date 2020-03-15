# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Queries::IssuesQuery, type: :request do
  before do
    host! 'api.example.com'
    create(:organization, issue_list: ['issue_def'])
    create(:organization, issue_list: ['issue_abc'])
  end

  describe '.resolve' do
    let(:data) { JSON.parse(response.body)['data']['issues'] }

    it 'returns issues' do
      post '/', params: { query: query }

      expect(data).to eq [{ 'name' => 'issue_abc' }, { 'name' => 'issue_def' }]
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
