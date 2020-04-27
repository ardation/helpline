# frozen_string_literal: true

class AddFeaturedToOrganizations < ActiveRecord::Migration[6.0]
  def change
    add_column :organizations, :featured, :boolean, index: true, default: false, null: false
  end
end
