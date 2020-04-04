# frozen_string_literal: true

class AddCodeIndexToCountries < ActiveRecord::Migration[6.0]
  def change
    add_index :countries, :code, unique: true
  end
end
