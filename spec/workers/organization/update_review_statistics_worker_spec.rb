# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Organization::UpdateReviewStatisticsWorker, type: :worker do
  subject(:job) { described_class.new }

  describe '#perform' do
    it 'does not raise error' do
      expect { job.perform(SecureRandom.uuid) }.not_to raise_error
    end

    context 'when organization exists' do
      let(:organization) { create(:organization) }

      before do
        allow(Organization).to receive(:find_by).with(id: organization.id).and_return(organization)
        allow(organization).to receive(:update_review_statistics)
      end

      it 'calls update_review_statistics' do
        job.perform(organization.id)
        expect(organization).to have_received(:update_review_statistics)
      end
    end
  end
end
