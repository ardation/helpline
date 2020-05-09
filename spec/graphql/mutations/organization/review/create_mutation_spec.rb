# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Mutations::Organization::Review::CreateMutation, type: :request do
  before { host! 'api.example.com' }

  let(:organization) { create(:organization) }

  describe '.resolve' do
    let(:data) { JSON.parse(response.body)['data']['organizationReviewCreate']['review'] }
    let(:review) { Organization::Review.find(data['id']) }
    let(:attributes) do
      {
        'id' => review.id,
        'content' => 'message',
        'rating' => 5
      }
    end

    it 'returns organization for provided slug' do
      post '/', params: { query: query(
        organization_id: organization.id, rating: 5, response_time: 10, recaptcha_token: 'abc', content: 'message'
      ) }
      expect(data).to include(attributes)
    end

    it 'sets response_time' do
      post '/', params: { query: query(
        organization_id: organization.id, rating: 5, response_time: 10, recaptcha_token: 'abc', content: 'message'
      ) }
      expect(review.response_time).to eq 10
    end

    context 'when verify_recaptcha fails' do
      let(:errors) { JSON.parse(response.body)['data']['organizationReviewCreate']['errors'] }

      before do
        stub_request(
          :get,
          'https://www.recaptcha.net/recaptcha/api/siteverify'\
          "?remoteip=127.0.0.1&response=abc&secret=#{ENV['RECAPTCHA_SECRET_KEY']}"
        ).to_return(body: { success: false }.to_json)
      end

      it 'returns error messages' do
        post '/', params: { query: query(
          organization_id: organization.id, rating: 5, response_time: 10, recaptcha_token: 'abc', content: 'message'
        ) }
        expect(errors).to eq ['reCAPTCHA verification failed, please try again.']
      end
    end
  end

  def query(organization_id:, rating:, response_time:, recaptcha_token:, content:)
    <<~GQL
      mutation Mutation {
        organizationReviewCreate(input: {
          organizationId: "#{organization_id}",
          rating: #{rating},
          responseTime: #{response_time},
          recaptchaToken: "#{recaptcha_token}",
          content: "#{content}"
        }) {
          review {
            id
            content
            rating
          }
          errors
        }
      }
    GQL
  end
end
