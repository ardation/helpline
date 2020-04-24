# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Organization::ImportWorker, type: :worker do
  subject(:job) { described_class.new }

  describe '#perform' do
    it 'does not raise error' do
      expect { job.perform(SecureRandom.uuid) }.not_to raise_error
    end

    context 'when import exists' do
      let(:import) { create(:organization_import) }

      before do
        allow(Organization::Import).to receive(:find_by).with(id: import.id).and_return(import)
        allow(import).to receive(:import)
      end

      it 'calls import' do
        job.perform(import.id)
        expect(import).to have_received(:import)
      end
    end
  end
end
