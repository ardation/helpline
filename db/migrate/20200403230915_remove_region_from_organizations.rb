# frozen_string_literal: true

class RemoveRegionFromOrganizations < ActiveRecord::Migration[6.0]
  def change
    remove_column :organizations, :region, :string
  end
end
