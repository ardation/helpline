# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Organization, type: :model do
  subject { build(:organization) }

  it { is_expected.to belong_to(:country).required }
  it { is_expected.to have_many(:opening_hours).dependent(:destroy) }
  it { is_expected.to have_many(:subdivision_connections).dependent(:destroy) }
  it { is_expected.to have_many(:subdivisions).through(:subdivision_connections) }
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:timezone) }
  it { is_expected.to validate_uniqueness_of(:name).scoped_to(:country_id) }
  it { is_expected.to allow_values(nil, '', 'http://foo.com', 'http://bar.com').for(:url) }
  it { is_expected.not_to allow_values('foo', 'buz').for(:url) }
  it { is_expected.to allow_values(nil, '', 'http://foo.com', 'http://bar.com').for(:chat_url) }
  it { is_expected.not_to allow_values('foo', 'buz').for(:chat_url) }
  it { is_expected.to allow_values(*ActiveSupport::TimeZone.all.map(&:name)).for(:timezone) }
  it { is_expected.not_to allow_values('test', 'place').for(:timezone) }
  it { is_expected.to accept_nested_attributes_for(:opening_hours).allow_destroy(true) }

  context 'when .filter_by_*' do
    let!(:organization_0) do
      create(
        :organization,
        country: create(:country, code: 'AU'),
        category_list: ['category_0'],
        human_support_type_list: ['human_support_type_0'],
        topic_list: ['topic_0']
      )
    end
    let(:country_nz) { create(:country, code: 'NZ') }
    let(:subdivision_auk) { create(:country_subdivision, country: country_nz, code: 'AUK') }
    let!(:organization_1) do
      create(
        :organization,
        country: country_nz,
        category_list: ['category_1'],
        human_support_type_list: ['human_support_type_1'],
        topic_list: ['topic_1']
      )
    end
    let!(:organization_2) do
      create(
        :organization,
        country: country_nz,
        subdivisions: [subdivision_auk],
        category_list: ['category_1'],
        human_support_type_list: ['human_support_type_1'],
        topic_list: ['topic_1']
      )
    end

    describe '.filter_by_country_code' do
      it 'returns organizations' do
        expect(described_class.filter_by_country_code('nz')).to match_array [organization_1, organization_2]
      end
    end

    describe '.filter_by_subdivison_codes' do
      it 'returns organizations' do
        expect(described_class.filter_by_subdivision_codes(['auk'])).to match_array [organization_2]
      end
    end

    describe '.filter_by_categories' do
      it 'returns organizations' do
        expect(described_class.filter_by_categories(['category_0'])).to match_array [organization_0]
      end
    end

    describe '.filter_by_human_support_type' do
      it 'returns organizations' do
        expect(described_class.filter_by_human_support_types(['human_support_type_0'])).to match_array [organization_0]
      end
    end

    describe '.filter_by_topics' do
      it 'returns organizations' do
        expect(described_class.filter_by_topics(['topic_0'])).to match_array [organization_0]
      end
    end
  end
end
