# frozen_string_literal: true

class CreateCountries < ActiveRecord::Migration[6.0]
  def change
    create_table :countries, id: :uuid do |t|
      t.string :code
      t.string :name
      t.string :emergency_number

      t.timestamps
    end
  end
end
