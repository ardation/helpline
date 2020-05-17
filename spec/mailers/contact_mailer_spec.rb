# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ContactMailer, type: :mailer do
  describe '#notify' do
    let(:contact) { create(:contact) }
    let(:mail) { described_class.notify(contact.id) }

    it 'sets subject' do
      expect(mail.subject).to eq('New contact submission on Find A Helpline')
    end

    it 'sets to address' do
      expect(mail.to).to eq(['contact@example.com'])
    end

    it 'sets from address' do
      expect(mail.from).to eq(['noreply@findahelpline.com'])
    end

    it 'sets reply_to address' do
      expect(mail.reply_to).to eq([contact.email])
    end

    it 'renders the body with subject' do
      expect(mail.body.encoded).to match(contact.subject)
    end

    it 'renders the body with message' do
      expect(mail.body.encoded).to match(contact.message)
    end

    context 'when contact does not exist' do
      let(:mail) { described_class.notify(SecureRandom.uuid) }

      it 'does not raise error' do
        expect { mail }.not_to raise_error
      end
    end
  end
end
