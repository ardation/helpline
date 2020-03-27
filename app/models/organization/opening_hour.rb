# frozen_string_literal: true

class Organization
  class OpeningHour < ApplicationRecord
    belongs_to :organization
    validates :close, :open, presence: true
    validates :day, uniqueness: { scope: :organization_id }, presence: true
    validate :open_before_close
    enum day: { monday: 1, tuesday: 2, wednesday: 3, thursday: 4, friday: 5, saturday: 6, sunday: 7 }

    protected

    def open_before_close
      errors.add(:closes, 'open must be before close') if open && close && open >= close
    end
  end
end
