# frozen_string_literal: true

class Country < ApplicationRecord
  SECOND_TIER_COUNTRIES = %w[GB-ENG GB-NIR GB-SCT GB-WLS].freeze
  has_many :organizations, dependent: :destroy
  has_many :subdivisions, dependent: :destroy
  enum locality: { state: 'state', county: 'county', province: 'province', location: 'location', region: 'region' }
  validates :locality, presence: true
  validates :code,
            presence: true,
            inclusion: { in: ISO3166::Country.all.map(&:alpha2) + SECOND_TIER_COUNTRIES },
            uniqueness: true

  def code=(code)
    super(code&.upcase)
  end

  def iso_3166_country
    return ISO3166::Country.new(code) unless SECOND_TIER_COUNTRIES.include?(code)

    country_code, subdivision_code = code.split('-')

    ISO3166::Country.new(country_code).subdivisions[subdivision_code]
  end

  def name(language = 'en')
    iso_3166_country&.translations&.[](language) || code
  end
end
