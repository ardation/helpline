# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Influencer, type: :model do
  subject(:influencer) { build(:influencer) }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:slug) }
  it { is_expected.to validate_presence_of(:message) }
  it { is_expected.to validate_uniqueness_of(:slug) }
  it { is_expected.to allow_value('correct-slug_name').for(:slug) }
  it { is_expected.not_to allow_value('Incorrect_SLUG').for(:slug) }

  it do
    expect(influencer).to validate_exclusion_of(:slug).in_array(
      ISO3166::Country.all.map(&:alpha2) + %w[
        organizations widget about contact embed get-the-widget gratitude privacy terms
      ]
    )
  end

  describe '#after_create' do
    subject(:influencer) { build(:influencer) }

    let!(:stub) { stub_request(:post, ENV['VERCEL_WEBHOOK_URL']) }

    it 'calls VERCEL_WEBHOOK_URL' do
      WebMock.reset_executed_requests!
      influencer.save
      expect(stub).to have_been_requested.once
    end
  end

  describe '#after_save' do
    subject!(:influencer) { create(:influencer) }

    let!(:stub) { stub_request(:post, ENV['VERCEL_WEBHOOK_URL']) }

    it 'calls VERCEL_WEBHOOK_URL' do
      WebMock.reset_executed_requests!
      influencer.update(name: 'abc')
      expect(stub).to have_been_requested.once
    end
  end

  describe '#after_destroy' do
    subject!(:influencer) { create(:influencer) }

    let!(:stub) { stub_request(:post, ENV['VERCEL_WEBHOOK_URL']) }

    it 'calls VERCEL_WEBHOOK_URL' do
      WebMock.reset_executed_requests!
      influencer.destroy
      expect(stub).to have_been_requested.once
    end
  end
end
