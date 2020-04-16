# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Country, type: :model do
  subject(:country) { build(:country) }

  it { is_expected.to have_many(:organizations).dependent(:destroy) }
  it { is_expected.to have_many(:subdivisions).dependent(:destroy) }
  it { is_expected.to validate_presence_of(:code) }
  it { is_expected.to validate_inclusion_of(:code).in_array(ISO3166::Country.all.map(&:alpha2)) }
  it { is_expected.to validate_uniqueness_of(:code).case_insensitive }

  describe '#code=' do
    it 'set code to upcase version' do
      country.code = 'us'
      expect(country.code).to eq 'US'
    end
  end

  describe '#name' do
    subject(:country) { build(:country, code: 'US') }

    it 'returns code as country name' do
      expect(country.name).to eq 'United States of America'
    end
  end

  describe '#iso_3166_country' do
    subject(:country) { build(:country, code: 'US') }

    it 'returns ISO3166::Country' do
      expect(country.iso_3166_country).to eq ISO3166::Country.new('US')
    end
  end

  describe '#after_create' do
    subject(:country) { build(:country) }

    let!(:stub) { stub_request(:post, ENV['ZEIT_WEBHOOK_URL']) }

    it 'calls ZEIT_WEBHOOK_URL' do
      WebMock.reset_executed_requests!
      country.save
      expect(stub).to have_been_requested.once
    end
  end

  describe '#after_save' do
    subject!(:country) { create(:country) }

    let!(:stub) { stub_request(:post, ENV['ZEIT_WEBHOOK_URL']) }

    it 'calls ZEIT_WEBHOOK_URL' do
      WebMock.reset_executed_requests!
      country.update(code: 'NZ')
      expect(stub).to have_been_requested.once
    end
  end

  describe '#after_destroy' do
    subject!(:country) { create(:country) }

    let!(:stub) { stub_request(:post, ENV['ZEIT_WEBHOOK_URL']) }

    it 'calls ZEIT_WEBHOOK_URL' do
      WebMock.reset_executed_requests!
      country.destroy
      expect(stub).to have_been_requested.once
    end
  end
end
