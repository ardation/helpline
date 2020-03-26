# frozen_string_literal: true

class AddTimezoneToOrganizations < ActiveRecord::Migration[6.0]
  def change
    add_column :organizations, :timezone, :string
    remove_column :organization_opening_hours, :timezone, :string
  end
end
