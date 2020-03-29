# frozen_string_literal: true

class Organization < ApplicationRecord
  acts_as_taggable_on :human_support_types, :topics, :categories
  extend FriendlyId
  friendly_id :name, use: :slugged
  belongs_to :country
  has_many :opening_hours, dependent: :destroy
  validates :name, presence: true, uniqueness: { scope: :country_id }
  validates :url, format: { with: URI::DEFAULT_PARSER.make_regexp }, allow_blank: true
  validates :chat_url, format: { with: URI::DEFAULT_PARSER.make_regexp }, allow_blank: true
  validates :timezone, inclusion: { in: ActiveSupport::TimeZone.all.map(&:name) }, presence: true
  accepts_nested_attributes_for :opening_hours, allow_destroy: true
end
