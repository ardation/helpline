# frozen_string_literal: true

class Country < ApplicationRecord
  has_many :organizations, dependent: :destroy
  validates :code, presence: true, inclusion: { in: ISO3166::Country.all.map(&:alpha2) }

  def code=(code)
    super(code&.upcase)
  end

  def name
    ISO3166::Country.new(code).name
  end
end
