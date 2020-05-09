# frozen_string_literal: true

class AddRatingToOrganizations < ActiveRecord::Migration[6.0]
  def change
    add_column :organizations, :rating, :float, default: 0, null: false
  end
end
