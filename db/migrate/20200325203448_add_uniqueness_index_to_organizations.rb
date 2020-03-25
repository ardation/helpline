# frozen_string_literal: true

class AddUniquenessIndexToOrganizations < ActiveRecord::Migration[6.0]
  def change
    add_index :organizations, %i[name country_code], unique: true
  end
end
