# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Mutations::Contact::CreateMutation, type: :request do
  before { host! 'api.example.com' }

  let(:organization) { create(:organization) }

  describe '.resolve' do
    let(:data) { JSON.parse(response.body)['data']['contactCreate']['contact'] }
    let(:contact) { attributes_for(:contact) }
    let(:attributes) do
      {
        'id' => data['id'],
        'email' => contact[:email],
        'subject' => contact[:subject],
        'message' => contact[:message]
      }
    end

    it 'creates contact' do
      post '/', params: { query: query(
        email: contact[:email], subject: contact[:subject], message: contact[:message], recaptcha_token: 'abc'
      ) }
      expect(data).to include(attributes)
    end

    context 'when verify_recaptcha fails' do
      let(:errors) { JSON.parse(response.body)['data']['contactCreate']['errors'] }

      before do
        stub_request(
          :get,
          'https://www.recaptcha.net/recaptcha/api/siteverify'\
          "?remoteip=127.0.0.1&response=abc&secret=#{ENV['RECAPTCHA_SECRET_KEY']}"
        ).to_return(body: { success: false }.to_json)
      end

      it 'returns error messages' do
        post '/', params: { query: query(
          email: contact[:email], subject: contact[:subject], message: contact[:message], recaptcha_token: 'abc'
        ) }
        expect(errors).to eq ['reCAPTCHA verification failed, please try again.']
      end
    end
  end

  def query(email:, subject:, message:, recaptcha_token:)
    <<~GQL
      mutation Mutation {
        contactCreate(input: {
          email: "#{email}",
          subject: "#{subject}",
          message: "#{message}",
          recaptchaToken: "#{recaptcha_token}"
        }) {
          contact {
            id
            email
            subject
            message
          }
          errors
        }
      }
    GQL
  end
end
