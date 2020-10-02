# frozen_string_literal: true

class Influencer < ApplicationRecord
  validates :name, :slug, :message, presence: true
  validates :slug, uniqueness: true, exclusion: {
    in: ISO3166::Country.all.map(&:alpha2) + %w[
      organizations widget about contact embed get-the-widget gratitude privacy terms
    ]
  }, format: { with: /\A[a-z0-9\-\_]+\z/, message: 'only allows lowercase letters, numbers and dashes' }
end
