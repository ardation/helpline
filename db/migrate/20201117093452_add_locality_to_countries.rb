# frozen_string_literal: true

class AddLocalityToCountries < ActiveRecord::Migration[6.0]
  def change
    add_column :countries, :locality, :string, default: 'location', null: false
  end
end
