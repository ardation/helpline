# frozen_string_literal: true

class Organization
  class OpeningHour < ApplicationRecord
    belongs_to :organization
    validates :close, :open, presence: true
    validates :day, presence: true
    validate :open_before_close
    validate :no_overlap
    enum day: { monday: 1, tuesday: 2, wednesday: 3, thursday: 4, friday: 5, saturday: 6, sunday: 7 }
    scope :overlapping, lambda { |opening_hour|
      where(organization: opening_hour.organization, day: opening_hour.day)
        .where.not(id: opening_hour.id)
        .where('open <= ? AND ? <= close', opening_hour.close, opening_hour.open)
    }

    protected

    def no_overlap
      return unless day && open && close && self.class.overlapping(self).exists?

      errors.add(:base, 'must not overlap with other opening hour')
    end

    def open_before_close
      errors.add(:closes, 'open must be before close') if open && close && open >= close
    end
  end
end
