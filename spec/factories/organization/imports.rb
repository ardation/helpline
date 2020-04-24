# frozen_string_literal: true

FactoryBot.define do
  factory :organization_import, class: 'Organization::Import' do
    user
    content do
      File.read(
        Rails.root.join(
          'spec', 'fixtures', 'files', 'services', 'organization', 'import_service', 'valid_organization.csv'
        )
      )
    end
  end
end
