# frozen_string_literal: true

FactoryBot.define do
  factory :organization_opening_hour, class: 'Organization::OpeningHour' do
    organization
    day { Organization::OpeningHour.days.keys.sample }
    open { Time.current.beginning_of_day }
    close { Time.current.end_of_day }
  end
end
