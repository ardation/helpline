# frozen_string_literal: true

class CreateCountrySubdivisions < ActiveRecord::Migration[6.0]
  def change
    create_table :country_subdivisions, id: :uuid do |t|
      t.belongs_to :country, null: false, foreign_key: { cascade: true }, type: :uuid, index: true
      t.string :code

      t.timestamps
    end

    add_index :country_subdivisions, %i[code country_id], unique: true
  end
end
