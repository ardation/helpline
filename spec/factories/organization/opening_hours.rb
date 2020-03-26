# frozen_string_literal: true

FactoryBot.define do
  factory :organization_opening_hour, class: 'Organization::OpeningHour' do
    organization
    day { (1..7).to_a.sample }
    open { Time.current.beginning_of_day }
    close { Time.current.end_of_day }
  end
end
