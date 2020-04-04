# frozen_string_literal: true

class Organization
  class SubdivisionConnection < ApplicationRecord
    belongs_to :subdivision, class_name: 'Country::Subdivision'
    belongs_to :organization
    validates :organization_id, uniqueness: { scope: :subdivision_id }
  end
end
