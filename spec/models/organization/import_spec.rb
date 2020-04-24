# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Organization::Import, type: :model do
  subject(:import) { build(:organization_import) }

  it { is_expected.to belong_to(:user) }
  it { is_expected.to validate_presence_of(:content) }

  describe '#content=' do
    it 'calls normalized_utf8' do
      allow(CsvEncodingService).to receive(:normalized_utf8).and_return('correct change')
      import.content = 'test'
      expect(import.content).to eq('correct change')
    end
  end

  describe '#import' do
    subject(:import) { create(:organization_import) }

    let(:time) { Time.zone.now.beginning_of_day }

    before do
      allow(Organization::ImportService).to receive(:import).and_return(nil)
    end

    it 'calls import service' do
      import.import
      expect(Organization::ImportService).to have_received(:import).with(import)
    end

    it 'does not set error message' do
      import.import
      expect(import.error_message).to be_nil
    end

    it 'sets imported_at' do
      travel_to time do
        import.import
        expect(import.imported_at).to eq time
      end
    end

    it 'sends notification email' do
      expect { import.import }.to(
        have_enqueued_job.on_queue('mailers')
                         .with('Organization::ImportMailer', 'notify', 'deliver_now', args: [import.id])
      )
    end

    context 'with errors' do
      before do
        allow(Organization::ImportService).to receive(:import).and_return("some\nerrors")
      end

      it 'sets error message' do
        import.import
        expect(import.error_message).to eq("<p>some\n<br />errors</p>")
      end
    end

    context 'when imported_at already set' do
      subject(:import) { build(:organization_import, imported_at: time) }

      it 'does not call import service' do
        import.import
        expect(Organization::ImportService).not_to have_received(:import)
      end

      it 'does not send notification email' do
        expect { import.import }.not_to(
          have_enqueued_job.on_queue('mailers')
                           .with('Organization::ImportMailer', 'notify', 'deliver_now', args: [import.id])
        )
      end
    end
  end

  describe '#queue_import' do
    it 'queues worker' do
      import.save
      expect(Organization::ImportWorker).to have_enqueued_sidekiq_job(import.id)
    end
  end
end
