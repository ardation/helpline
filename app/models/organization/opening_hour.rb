# frozen_string_literal: true

class Organization
  class OpeningHour < ApplicationRecord
    belongs_to :organization
    validates :close, :open, :timezone, presence: true
    validates :day, inclusion: { in: 1..7 }
    validates :timezone, inclusion: { in: ActiveSupport::TimeZone.all.map(&:name) }
    validate :open_before_close

    protected

    def open_before_close
      errors.add(:closes, 'open must be before close') if open && close && open >= close
    end
  end
end
