# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Country, type: :model do
  subject(:country) { build(:country) }

  it { is_expected.to have_many(:organizations).dependent(:destroy) }
  it { is_expected.to have_many(:subdivisions).dependent(:destroy) }
  it { is_expected.to validate_presence_of(:locality) }
  it { is_expected.to validate_presence_of(:code) }
  it { is_expected.to validate_uniqueness_of(:code).case_insensitive }

  it do
    expect(country).to(
      define_enum_for(:locality)
        .with_values(state: 'state', county: 'county', province: 'province', location: 'location', region: 'region')
        .backed_by_column_of_type(:string)
    )
  end

  it do
    expect(country).to(
      validate_inclusion_of(:code).in_array(ISO3166::Country.all.map(&:alpha2) + described_class::SECOND_TIER_COUNTRIES)
    )
  end

  describe '#locality' do
    it 'returns location by default' do
      expect(country.locality).to eq 'location'
    end
  end

  describe '#code=' do
    it 'set code to upcase version' do
      country.code = 'us'
      expect(country.code).to eq 'US'
    end
  end

  describe '#name' do
    subject(:country) { build(:country, code: 'US') }

    it 'returns code as country name' do
      expect(country.name).to eq 'United States'
    end

    context 'when code is GB-ENG' do
      subject(:country) { build(:country, code: 'GB-ENG') }

      it 'returns code as country name' do
        expect(country.name).to eq 'England'
      end
    end

    context 'when code is GB-ENG and language is fr' do
      subject(:country) { build(:country, code: 'GB-ENG') }

      it 'returns code as country name' do
        expect(country.name('fr')).to eq 'Angleterre'
      end
    end
  end

  describe '#iso_3166_country' do
    subject(:country) { build(:country, code: 'US') }

    it 'returns ISO3166::Country' do
      expect(country.iso_3166_country).to eq ISO3166::Country.new('US')
    end

    context 'when code is GB-ENG' do
      subject(:country) { build(:country, code: 'GB-ENG') }

      it 'returns ISO3166::Subdivision' do
        expect(country.iso_3166_country).to eq ISO3166::Country.new('GB').subdivisions['ENG']
      end
    end
  end

  describe '#after_create' do
    subject(:country) { build(:country) }

    let!(:stub) { stub_request(:post, ENV['VERCEL_WEBHOOK_URL']) }

    it 'calls VERCEL_WEBHOOK_URL' do
      WebMock.reset_executed_requests!
      country.save
      expect(stub).to have_been_requested.once
    end
  end

  describe '#after_save' do
    subject!(:country) { create(:country) }

    let!(:stub) { stub_request(:post, ENV['VERCEL_WEBHOOK_URL']) }

    it 'calls VERCEL_WEBHOOK_URL' do
      WebMock.reset_executed_requests!
      country.update(code: 'NZ')
      expect(stub).to have_been_requested.once
    end
  end

  describe '#after_destroy' do
    subject!(:country) { create(:country) }

    let!(:stub) { stub_request(:post, ENV['VERCEL_WEBHOOK_URL']) }

    it 'calls VERCEL_WEBHOOK_URL' do
      WebMock.reset_executed_requests!
      country.destroy
      expect(stub).to have_been_requested.once
    end
  end
end
