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

    it 'returns code as country name' do
      expect(subdivision.name).to eq 'Alabama'
    end
  end

  describe '#iso_3166_subdivision' do
    subject(:subdivision) { build(:country_subdivision, country: country, code: 'AL') }

    let(:country) { build(:country, code: 'US') }

    it 'returns ISO3166::Subdivision' do
      expect(subdivision.iso_3166_subdivision).to eq ISO3166::Country.new('US').subdivisions['AL']
    end
  end
end
