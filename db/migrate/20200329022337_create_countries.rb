# frozen_string_literal: true

class CreateCountries < ActiveRecord::Migration[6.0]
  def change
    create_table :countries, id: :uuid do |t|
      t.string :code
      t.string :name
      t.string :emergency_number

      t.timestamps
    end

    remove_column :organizations, :country_code, :string, null: false
    add_column :organizations, :country_id, :uuid, null: false
    add_foreign_key :organizations, :countries
    add_index :organizations, :country_id
    add_index :organizations, %i[name country_id], unique: true
  end
end
