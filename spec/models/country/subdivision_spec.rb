# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Country::Subdivision, type: :model do
  subject(:subdivision) { build(:country_subdivision) }

  it { is_expected.to belong_to(:country) }
  it { is_expected.to have_many(:subdivision_connections).dependent(:destroy) }
  it { is_expected.to have_many(:organizations).through(:subdivision_connections) }
  it { is_expected.to validate_inclusion_of(:code).in_array(subdivision.country.iso_3166_country.subdivisions.keys) }
  it { is_expected.to validate_uniqueness_of(:code).scoped_to(:country_id).case_insensitive }

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

    context 'when country NZ and subdivision is CIT' do
      subject(:subdivision) { build(:country_subdivision, country: country, code: 'CIT') }

      let(:country) { build(:country, code: 'NZ') }

      it 'returns code' do
        expect(subdivision.name).to eq 'CIT'
      end
    end
  end

  describe '#iso_3166_subdivision' do
    subject(:subdivision) { build(:country_subdivision, country: country, code: 'AL') }

    let(:country) { build(:country, code: 'US') }

    it 'returns ISO3166::Subdivision' do
      expect(subdivision.iso_3166_subdivision).to eq ISO3166::Country.new('US').subdivisions['AL']
    end
  end

  describe '#after_create' do
    subject(:subdivision) { build(:country_subdivision, country: country) }

    let!(:country) { create(:country, code: 'US') }
    let!(:stub) { stub_request(:get, ENV['ZEIT_WEBHOOK_URL']) }

    it 'calls ZEIT_WEBHOOK_URL' do
      WebMock.reset_executed_requests!
      subdivision.save
      expect(stub).to have_been_requested.once
    end
  end

  describe '#after_save' do
    subject!(:subdivision) { create(:country_subdivision, country: country, code: 'AL') }

    let!(:country) { create(:country, code: 'US') }
    let!(:stub) { stub_request(:get, ENV['ZEIT_WEBHOOK_URL']) }

    it 'calls ZEIT_WEBHOOK_URL' do
      WebMock.reset_executed_requests!
      subdivision.update(code: 'FL')
      expect(stub).to have_been_requested.once
    end
  end

  describe '#after_destroy' do
    subject!(:subdivision) { create(:country_subdivision) }

    let!(:stub) { stub_request(:get, ENV['ZEIT_WEBHOOK_URL']) }

    it 'calls ZEIT_WEBHOOK_URL' do
      WebMock.reset_executed_requests!
      subdivision.destroy
      expect(stub).to have_been_requested.once
    end
  end
end
