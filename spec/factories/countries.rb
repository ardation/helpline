# frozen_string_literal: true

FactoryBot.define do
  factory :country do
    code { ISO3166::Country.all.map(&:alpha2).sample }
  end
end
