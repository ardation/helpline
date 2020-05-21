# frozen_string_literal: true

class AddVerifiedToOrganizations < ActiveRecord::Migration[6.0]
  def change
    add_column :organizations, :verified, :boolean, index: true, default: false, null: false
  end
end
