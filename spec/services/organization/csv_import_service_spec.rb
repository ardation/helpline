# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Organization::CsvImportService, type: :service do
  let(:csv) { file_fixture('services/organization/csv_import_service/valid_organization.csv') }

  describe '.import' do
    let(:organization) { Organization.first }
    let(:opening_hour) { organization.opening_hours.first }
    let(:organization_attributes) do
      {
        'name' => 'Youthline',
        'country_id' => Country.find_by(code: 'NZ').id,
        'phone_word' => '0800 YOUTHLINE',
        'phone_number' => '0800 376 633',
        'sms_word' => 'WORD',
        'sms_number' => '234',
        'chat_url' => 'https://www.youthline.co.nz/web-chat-counselling.html',
        'url' => 'https://www.youthline.co.nz',
        'slug' => 'youthline',
        'notes' => 'no notes needed',
        'timezone' => 'Auckland',
        'remote_id' => 'TestRemoteId'
      }
    end
    let(:opening_hour_attributes) do
      {
        'day' => 'monday',
        'open' => DateTime.new(2000, 1, 1, 11, 31),
        'close' => DateTime.new(2000, 1, 1, 20, 20)
      }
    end

    it 'creates organization' do
      expect { described_class.import(csv) }.to change(Organization, :count).by(1)
    end

    it 'has the correct organization attributes' do
      described_class.import(csv)
      expect(organization.attributes).to include(organization_attributes)
    end

    it 'has the correct human_support_type_list' do
      described_class.import(csv)
      expect(organization.human_support_type_list).to match_array ['Volunteers', 'Paid Staff']
    end

    it 'has the correct topic_list' do
      described_class.import(csv)
      expect(organization.topic_list).to match_array %w[Anxiety Bullying]
    end

    it 'has the correct category_list' do
      described_class.import(csv)
      expect(organization.category_list).to match_array ['All topics', 'For youth']
    end

    it 'has the correct subdivisions' do
      described_class.import(csv)
      expect(organization.subdivisions).to match_array [
        Country::Subdivision.find_by(code: 'AUK'), Country::Subdivision.find_by(code: 'BOP')
      ]
    end

    it 'has the correct opening_hour attributes' do
      described_class.import(csv)
      expect(opening_hour.attributes).to include(opening_hour_attributes)
    end

    context 'when organization already exists with same name and country' do
      let!(:organization) { create(:organization, name: 'Youthline', country: create(:country, code: 'NZ')) }

      it 'does not create organization' do
        expect { described_class.import(csv) }.not_to change(Organization, :count)
      end

      it 'has the correct attributes' do
        described_class.import(csv)
        expect(organization.reload.attributes).to include(organization_attributes)
      end
    end

    context 'when organization already exists with same remote_id' do
      let!(:organization) { create(:organization, remote_id: 'TestRemoteId') }

      it 'does not create organization' do
        expect { described_class.import(csv) }.not_to change(Organization, :count)
      end

      it 'has the correct attributes' do
        described_class.import(csv)
        expect(organization.reload.attributes).to include(organization_attributes)
      end
    end

    context 'when csv row is invalid' do
      let(:csv) { file_fixture('services/organization/csv_import_service/invalid_organization.csv') }

      it 'raises error' do
        expect { described_class.import(csv) }.to raise_error(
          Organization::CsvImportService::ValidationError,
          /Row 1: Country must exist, Name can't be blank/
        )
      end
    end

    context 'when csv row is always_open' do
      let(:csv) { file_fixture('services/organization/csv_import_service/valid_organization_always_open.csv') }

      it 'sets always_open to true' do
        described_class.import(csv)
        expect(organization.always_open).to eq(true)
      end
    end
  end
end
