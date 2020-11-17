# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Country::Subdivision, type: :model do
  subject(:subdivision) { build(:country_subdivision) }

  it { is_expected.to belong_to(:country) }
  it { is_expected.to have_many(:subdivision_connections).dependent(:destroy) }
  it { is_expected.to have_many(:organizations).through(:subdivision_connections) }
  it { is_expected.to validate_inclusion_of(:code).in_array(subdivision.country.iso_3166_country.subdivisions.keys) }
  it { is_expected.to validate_uniqueness_of(:code).scoped_to(:country_id).case_insensitive }


  context 'when country is GB-ENG' do
    subject(:subdivision) { build(:country_subdivision, country: country) }

    let(:country) { build(:country, code: 'GB-ENG') }

    it { is_expected.to validate_inclusion_of(:code).in_array(ISO3166::Country.new('GB').subdivisions.keys) }
  end

  describe '#code=' do
    it 'set code to upcase version' do
      subdivision.code = 'al'
      expect(subdivision.code).to eq 'AL'
    end
  end

  describe '#name' do
    subject(:subdivision) { build(:country_subdivision, country: country, code: 'AL') }

    let(:country) { build(:country, code: 'US') }

    it 'returns code as subdivision name' do
      expect(subdivision.name).to eq 'Alabama'
    end

    context 'when country IE and subdivision is L' do
      subject(:subdivision) { build(:country_subdivision, country: country, code: 'L') }

      let(:country) { build(:country, code: 'IE') }

      it 'returns code' do
        expect(subdivision.name).to eq 'Leinster'
      end
    end

    context 'when country GB and subdivision is SCT' do
      subject(:subdivision) { build(:country_subdivision, country: country, code: 'SCT') }

      let(:country) { build(:country, code: 'GB') }

      it 'returns code' do
        expect(subdivision.name).to eq 'Scotland'
      end

      it 'returns code in german' do
        expect(subdivision.name('de')).to eq 'Schottland'
      end
    end
  end

  describe '#iso_3166_country' do
    subject(:subdivision) { build(:country_subdivision, country: country) }

    let(:country) { build(:country, code: 'US') }

    it 'returns ISO3166::Country' do
      expect(subdivision.iso_3166_country).to eq ISO3166::Country.new('US')
    end

    context 'when country is GB-ENG' do
      let(:country) { build(:country, code: 'GB-ENG') }

      it 'returns ISO3166::Country' do
        expect(subdivision.iso_3166_country).to eq ISO3166::Country.new('GB')
      end
    end

    context 'when country is nil' do
      subject(:subdivision) { build(:country_subdivision, country: nil) }

      it 'returns nil' do
        expect(subdivision.iso_3166_country).to be_nil
      end
    end
  end

  describe '#iso_3166_subdivision' do
    subject(:subdivision) { build(:country_subdivision, country: country, code: 'AL') }

    let(:country) { build(:country, code: 'US') }

    it 'returns ISO3166::Subdivision' do
      expect(subdivision.iso_3166_subdivision).to eq ISO3166::Country.new('US').subdivisions['AL']
    end

    context 'when country is GB-ENG' do
      subject(:subdivision) { build(:country_subdivision, country: country, code: 'BKM') }

      let(:country) { build(:country, code: 'GB-ENG') }

      it 'returns ISO3166::Subdivision' do
        expect(subdivision.iso_3166_subdivision).to eq ISO3166::Country.new('GB').subdivisions['BKM']
      end
    end
  end

  describe '#after_create' do
    subject(:subdivision) { build(:country_subdivision, country: country) }

    let!(:country) { create(:country, code: 'US') }
    let!(:stub) { stub_request(:post, ENV['VERCEL_WEBHOOK_URL']) }

    it 'calls VERCEL_WEBHOOK_URL' do
      WebMock.reset_executed_requests!
      subdivision.save
      expect(stub).to have_been_requested.once
    end
  end

  describe '#after_save' do
    subject!(:subdivision) { create(:country_subdivision, country: country, code: 'AL') }

    let!(:country) { create(:country, code: 'US') }
    let!(:stub) { stub_request(:post, ENV['VERCEL_WEBHOOK_URL']) }

    it 'calls VERCEL_WEBHOOK_URL' do
      WebMock.reset_executed_requests!
      subdivision.update(code: 'FL')
      expect(stub).to have_been_requested.once
    end
  end

  describe '#after_destroy' do
    subject!(:subdivision) { create(:country_subdivision) }

    let!(:stub) { stub_request(:post, ENV['VERCEL_WEBHOOK_URL']) }

    it 'calls VERCEL_WEBHOOK_URL' do
      WebMock.reset_executed_requests!
      subdivision.destroy
      expect(stub).to have_been_requested.once
    end
  end
end
