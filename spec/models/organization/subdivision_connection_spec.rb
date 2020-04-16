# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Organization::SubdivisionConnection, type: :model do
  subject { build(:organization_subdivision_connection) }

  it { is_expected.to belong_to(:organization) }
  it { is_expected.to belong_to(:subdivision) }
  it { is_expected.to validate_uniqueness_of(:organization_id).scoped_to(:subdivision_id).case_insensitive }

  describe '#after_create' do
    subject(:subdivision_connection) do
      build(:organization_subdivision_connection, organization: organization, subdivision: subdivision)
    end

    let!(:organization) { create(:organization) }
    let!(:subdivision) { create(:country_subdivision) }
    let!(:stub) { stub_request(:post, ENV['ZEIT_WEBHOOK_URL']) }

    it 'calls ZEIT_WEBHOOK_URL' do
      WebMock.reset_executed_requests!
      subdivision_connection.save
      expect(stub).to have_been_requested.once
    end
  end

  describe '#after_destroy' do
    subject!(:subdivision_connection) { create(:organization_subdivision_connection) }

    let!(:stub) { stub_request(:post, ENV['ZEIT_WEBHOOK_URL']) }

    it 'calls ZEIT_WEBHOOK_URL' do
      WebMock.reset_executed_requests!
      subdivision_connection.destroy
      expect(stub).to have_been_requested.once
    end
  end
end
