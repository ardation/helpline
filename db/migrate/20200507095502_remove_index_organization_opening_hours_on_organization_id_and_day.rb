# frozen_string_literal: true

class RemoveIndexOrganizationOpeningHoursOnOrganizationIdAndDay < ActiveRecord::Migration[6.0]
  def up
    remove_index :organization_opening_hours, name: 'index_organization_opening_hours_on_organization_id_and_day'
  end

  def down
    add_index :organization_opening_hours, %i[organization_id day], unique: true
  end
end
