# frozen_string_literal: true

class Organization < ApplicationRecord
  acts_as_taggable_on :human_support_types, :issues, :categories
  extend FriendlyId
  friendly_id :name, use: :slugged
  has_many :opening_hours, dependent: :destroy
  validates :name, presence: true, uniqueness: { scope: :country_code }
  validates :country_code, presence: true, inclusion: { in: ISO3166::Country.all.map(&:alpha2) }
  validates :url, format: { with: URI::DEFAULT_PARSER.make_regexp }, allow_blank: true
  validates :chat_url, format: { with: URI::DEFAULT_PARSER.make_regexp }, allow_blank: true
  validates :timezone, inclusion: { in: ActiveSupport::TimeZone.all.map(&:name) }, presence: true
  accepts_nested_attributes_for :opening_hours, allow_destroy: true
end
