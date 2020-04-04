# frozen_string_literal: true

class RemoveNameFromCountries < ActiveRecord::Migration[6.0]
  def change
    remove_column :countries, :name, :string
  end
end
