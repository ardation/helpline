# frozen_string_literal: true

class AddAlwaysOpenToOrganizations < ActiveRecord::Migration[6.0]
  def change
    add_column :organizations, :always_open, :boolean, default: false
  end
end
