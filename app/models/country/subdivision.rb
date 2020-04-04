# frozen_string_literal: true

class Country
  class Subdivision < ApplicationRecord
    belongs_to :country
    has_many :subdivision_connections, dependent: :destroy, class_name: 'Organization::SubdivisionConnection'
    has_many :organizations, through: :subdivision_connections
    validates :code,
              presence: true,
              inclusion: { in: :subdivision_codes }
    delegate :name, to: :iso_3166_subdivision

    def code=(code)
      super(code&.upcase)
    end

    def iso_3166_subdivision
      ISO3166::Country.new(country.code).subdivisions[code]
    end

    private

    def subdivision_codes
      country&.iso_3166_country&.subdivisions&.keys || []
    end
  end
end
