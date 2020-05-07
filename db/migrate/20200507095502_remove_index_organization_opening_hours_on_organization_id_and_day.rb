# frozen_string_literal: true

class RemoveIndexOrganizationOpeningHoursOnOrganizationIdAndDay < ActiveRecord::Migration[6.0]
  def change
    remove_index :organization_opening_hours, name: 'index_organization_opening_hours_on_organization_id_and_day'
  end
end
