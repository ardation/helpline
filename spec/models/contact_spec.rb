# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Contact, type: :model do
  subject(:contact) { build(:contact) }

  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_presence_of(:subject) }
  it { is_expected.to validate_presence_of(:message) }
  it { is_expected.to validate_presence_of(:recaptcha_token).on(:create) }
  it { is_expected.to validate_presence_of(:remote_ip).on(:create) }
  it { is_expected.to allow_value('email@addresse.foo').for(:email) }
  it { is_expected.not_to allow_value('foo').for(:email) }

  describe '#validate_recaptcha' do
    it 'sets recaptcha_score' do
      contact.save
      expect(contact.recaptcha_score).to eq 0.5
    end

    context 'when verify_recaptcha fails' do
      before do
        stub_request(
          :get,
          'https://www.recaptcha.net/recaptcha/api/siteverify'\
          "?remoteip=127.0.0.1&response=abc&secret=#{ENV['RECAPTCHA_SECRET_KEY']}"
        ).to_return(body: { success: false }.to_json)
      end

      it 'is not valid' do
        expect(contact).not_to be_valid
      end

      it 'returns error message' do
        contact.save
        expect(contact.errors.messages[:base]).to eq ['reCAPTCHA verification failed, please try again.']
      end
    end
  end

  describe '#queue_mailer' do
    subject(:contact) { build(:contact, id: SecureRandom.uuid) }

    it 'sends notification email' do
      expect { contact.save }.to(
        have_enqueued_job.on_queue('mailers')
                         .with('ContactMailer', 'notify', 'deliver_now', args: [contact.id])
      )
    end
  end
end
