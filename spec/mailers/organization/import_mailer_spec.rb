# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Organization::ImportMailer, type: :mailer do
  describe '#notify' do
    let(:import) { create(:organization_import) }
    let(:mail) { described_class.notify(import.id) }

    it 'sets subject' do
      expect(mail.subject).to eq('Your organization CSV import is complete')
    end

    it 'sets to address' do
      expect(mail.to).to eq([import.user.email])
    end

    it 'sets from address' do
      expect(mail.from).to eq(['noreply@findahelpline.com'])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to match("Hey #{import.user.email},")
    end

    context 'when import does not exist' do
      let(:mail) { described_class.notify(SecureRandom.uuid) }

      it 'does not raise error' do
        expect { mail }.not_to raise_error
      end
    end
  end
end
