# frozen_string_literal: true

class AddUniquenessIndexToOpeningHours < ActiveRecord::Migration[6.0]
  def change
    add_index :organization_opening_hours, %i[organization_id day], unique: true
  end
end
