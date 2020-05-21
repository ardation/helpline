# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Organization, type: :model do
  subject(:organization) { build(:organization) }

  it { is_expected.to belong_to(:country).required }
  it { is_expected.to have_many(:opening_hours).dependent(:destroy) }
  it { is_expected.to have_many(:reviews).dependent(:destroy) }
  it { is_expected.to have_many(:published_reviews) }
  it { is_expected.to have_many(:subdivision_connections).dependent(:destroy) }
  it { is_expected.to have_many(:subdivisions).through(:subdivision_connections) }
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:timezone) }
  it { is_expected.to validate_uniqueness_of(:name).scoped_to(:country_id) }
  it { is_expected.to validate_uniqueness_of(:remote_id).allow_nil }
  it { is_expected.to allow_values(nil, '', 'http://foo.com', 'http://bar.com').for(:url) }
  it { is_expected.not_to allow_values('foo', 'buz').for(:url) }
  it { is_expected.to allow_values(nil, '', 'http://foo.com', 'http://bar.com').for(:chat_url) }
  it { is_expected.not_to allow_values('foo', 'buz').for(:chat_url) }
  it { is_expected.to allow_values(*ActiveSupport::TimeZone.all.map(&:name)).for(:timezone) }
  it { is_expected.not_to allow_values('test', 'place').for(:timezone) }
  it { is_expected.to accept_nested_attributes_for(:opening_hours).allow_destroy(true) }

  describe '#published_reviews' do
    subject(:organization) { create(:organization) }

    let!(:review) { create(:organization_review, published: true, organization: organization) }

    before do
      create(:organization_review, organization: organization)
      create(:organization_review, published: true)
    end

    it 'returns published reviews' do
      expect(organization.published_reviews).to eq [review]
    end
  end

  context 'when .filter_by_*' do
    let!(:organization_0) do
      create(
        :organization,
        country: create(:country, code: 'AU'),
        category_list: ['category_0'],
        human_support_type_list: ['human_support_type_0'],
        topic_list: ['topic_0'],
        featured: true,
        verified: true
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

      it 'allows use by filter' do
        expect(described_class.filter(country_code: 'nz')).to match_array [organization_1, organization_2]
      end
    end

    describe '.filter_by_subdivison_codes' do
      it 'returns organizations' do
        expect(described_class.filter_by_subdivision_codes(['auk'])).to match_array [organization_2]
      end

      it 'allows use by filter' do
        expect(described_class.filter(subdivision_codes: ['auk'])).to match_array [organization_2]
      end

      it 'returns organizations when empty' do
        expect(
          described_class.filter_by_country_code('nz').filter_by_subdivision_codes([])
        ).to match_array [organization_1]
      end

      it 'returns organizations when nil' do
        expect(
          described_class.filter_by_country_code('nz').filter_by_subdivision_codes([nil])
        ).to match_array [organization_1]
      end

      it 'returns national organizations and subdivision organizations when nil present' do
        expect(
          described_class.filter_by_country_code('nz').filter_by_subdivision_codes([nil, 'auk'])
        ).to match_array [organization_1, organization_2]
      end

      it 'allows use by filter when empty' do
        expect(described_class.filter(country_code: 'nz', subdivision_codes: [])).to match_array [organization_1]
      end
    end

    describe '.filter_by_categories' do
      it 'returns organizations' do
        expect(described_class.filter_by_categories(['category_0'])).to match_array [organization_0]
      end

      it 'allows use by filter' do
        expect(described_class.filter(categories: ['category_0'])).to match_array [organization_0]
      end
    end

    describe '.filter_by_human_support_type' do
      it 'returns organizations' do
        expect(described_class.filter_by_human_support_types(['human_support_type_0'])).to match_array [organization_0]
      end

      it 'allows use by filter' do
        expect(described_class.filter(human_support_types: ['human_support_type_0'])).to match_array [organization_0]
      end
    end

    describe '.filter_by_topics' do
      it 'returns organizations' do
        expect(described_class.filter_by_topics(['topic_0'])).to match_array [organization_0]
      end

      it 'allows use by filter' do
        expect(described_class.filter(topics: ['topic_0'])).to match_array [organization_0]
      end
    end

    describe '.filter_by_featured' do
      it 'returns organizations when true' do
        expect(described_class.filter_by_featured(true)).to match_array [organization_0]
      end

      it 'returns organizations when false' do
        expect(described_class.filter_by_featured(false)).to match_array [organization_1, organization_2]
      end

      it 'allows use by filter' do
        expect(described_class.filter(featured: true)).to match_array [organization_0]
      end
    end

    describe '.filter_by_verified' do
      it 'returns organizations when true' do
        expect(described_class.filter_by_verified(true)).to match_array [organization_0]
      end

      it 'returns organizations when false' do
        expect(described_class.filter_by_verified(false)).to match_array [organization_1, organization_2]
      end

      it 'allows use by filter' do
        expect(described_class.filter(verified: true)).to match_array [organization_0]
      end
    end
  end

  describe '#after_create' do
    subject(:organization) { build(:organization, country: country) }

    let!(:country) { create(:country) }
    let!(:stub) { stub_request(:post, ENV['ZEIT_WEBHOOK_URL']) }

    it 'calls ZEIT_WEBHOOK_URL' do
      WebMock.reset_executed_requests!
      organization.save
      expect(stub).to have_been_requested.once
    end
  end

  describe '#after_save' do
    subject!(:organization) { create(:organization) }

    let!(:stub) { stub_request(:post, ENV['ZEIT_WEBHOOK_URL']) }

    it 'calls ZEIT_WEBHOOK_URL' do
      WebMock.reset_executed_requests!
      organization.update(name: 'abc')
      expect(stub).to have_been_requested.once
    end
  end

  describe '#after_destroy' do
    subject!(:organization) { create(:organization) }

    let!(:stub) { stub_request(:post, ENV['ZEIT_WEBHOOK_URL']) }

    it 'calls ZEIT_WEBHOOK_URL' do
      WebMock.reset_executed_requests!
      organization.destroy
      expect(stub).to have_been_requested.once
    end
  end

  describe '#should_generate_new_friendly_id?' do
    subject!(:organization) { create(:organization) }

    it 'returns false' do
      expect(organization.should_generate_new_friendly_id?).to be(false)
    end

    context 'when name changed' do
      it 'returns true' do
        organization.name = 'test'
        expect(organization.should_generate_new_friendly_id?).to be(true)
      end
    end
  end

  describe '#remote_id=' do
    it 'sets empty string to nil' do
      organization.remote_id = ''
      expect(organization.remote_id).to be_nil
    end

    it 'sets remote_id' do
      organization.remote_id = 'remote_id'
      expect(organization.remote_id).to eq 'remote_id'
    end
  end

  describe '#update_review_statistics' do
    it 'sets rating' do
      organization.update_review_statistics
      expect(organization.rating).to eq 0
    end

    context 'when reviews exist' do
      before do
        create(:organization_review, organization: organization, rating: 5, published: true)
        create(:organization_review, organization: organization, rating: 5, published: false)
        create(:organization_review, organization: organization, rating: 2, published: true)
      end

      it 'sets rating' do
        organization.update_review_statistics
        expect(organization.rating).to eq 3.5
      end

      it 'sets review_count' do
        organization.update_review_statistics
        expect(organization.review_count).to eq 2
      end
    end
  end
end
