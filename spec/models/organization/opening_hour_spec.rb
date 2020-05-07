# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Organization::OpeningHour, type: :model do
  subject(:opening_hour) { create(:organization_opening_hour) }

  it { is_expected.to belong_to(:organization) }
  it { is_expected.to validate_presence_of(:close) }
  it { is_expected.to validate_presence_of(:open) }
  it { is_expected.to validate_presence_of(:day) }

  it do
    expect(opening_hour).to define_enum_for(:day).with_values(
      monday: 1, tuesday: 2, wednesday: 3, thursday: 4, friday: 5, saturday: 6, sunday: 7
    )
  end

  describe '.overlapping' do
    subject(:overlapping_opening_hour) { build(:organization_opening_hour, day: 'monday', organization: organization) }

    let(:organization) { create(:organization) }
    let!(:opening_hour) { create(:organization_opening_hour, day: 'monday', organization: organization) }

    it 'returns opening hour' do
      expect(described_class.overlapping(overlapping_opening_hour)).to eq [opening_hour]
    end

    context 'when different day' do
      subject(:other_opening_hour) { build(:organization_opening_hour, day: 'tuesday', organization: organization) }

      it 'returns blank' do
        expect(described_class.overlapping(other_opening_hour)).to eq []
      end
    end

    context 'when different organization' do
      subject(:other_opening_hour) { build(:organization_opening_hour, day: 'monday') }

      it 'returns blank' do
        expect(described_class.overlapping(other_opening_hour)).to eq []
      end
    end
  end

  describe '#no_overlap' do
    subject(:opening_hour) { build(:organization_opening_hour, day: 'monday', organization: organization) }

    let(:organization) { create(:organization) }

    before { create(:organization_opening_hour, day: 'monday', organization: organization) }

    it { is_expected.not_to be_valid }

    context 'when different day' do
      subject(:opening_hour) { build(:organization_opening_hour, day: 'tuesday', organization: organization) }

      it { is_expected.to be_valid }
    end

    context 'when different organization' do
      subject(:opening_hour) { build(:organization_opening_hour, day: 'monday') }

      it { is_expected.to be_valid }
    end
  end

  describe '#open_before_close' do
    before do
      opening_hour.open = Time.current.end_of_day
      opening_hour.close = Time.current.beginning_of_day
    end

    it { is_expected.not_to be_valid }
  end

  describe '#after_create' do
    subject(:opening_hour) { build(:organization_opening_hour, organization: organization) }

    let!(:organization) { create(:organization) }
    let!(:stub) { stub_request(:post, ENV['ZEIT_WEBHOOK_URL']) }

    it 'calls ZEIT_WEBHOOK_URL' do
      WebMock.reset_executed_requests!
      opening_hour.save
      expect(stub).to have_been_requested.once
    end
  end

  describe '#after_save' do
    subject!(:opening_hour) { create(:organization_opening_hour) }

    let!(:stub) { stub_request(:post, ENV['ZEIT_WEBHOOK_URL']) }

    it 'calls ZEIT_WEBHOOK_URL' do
      WebMock.reset_executed_requests!
      opening_hour.update(day: 'tuesday')
      expect(stub).to have_been_requested.once
    end
  end

  describe '#after_destroy' do
    subject!(:opening_hour) { create(:organization_opening_hour) }

    let!(:stub) { stub_request(:post, ENV['ZEIT_WEBHOOK_URL']) }

    it 'calls ZEIT_WEBHOOK_URL' do
      WebMock.reset_executed_requests!
      opening_hour.destroy
      expect(stub).to have_been_requested.once
    end
  end
end
