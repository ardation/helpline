# frozen_string_literal: true

class Country
  class Subdivision < ApplicationRecord
    belongs_to :country
    has_many :subdivision_connections, dependent: :destroy, class_name: 'Organization::SubdivisionConnection'
    has_many :organizations, through: :subdivision_connections
    validates :code,
              presence: true,
              inclusion: { in: :subdivision_codes },
              uniqueness: { scope: :country_id }

    def code=(code)
      super(code&.upcase)
    end

    def iso_3166_subdivision
      ISO3166::Country.new(country.code).subdivisions[code]
    end

    def name
      iso_3166_subdivision.name || ''
    end

    private

    def subdivision_codes
      country&.iso_3166_country&.subdivisions&.keys || []
    end
  end
end
