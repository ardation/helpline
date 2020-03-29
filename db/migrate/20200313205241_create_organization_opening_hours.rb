# frozen_string_literal: true

class CreateOrganizationOpeningHours < ActiveRecord::Migration[6.0]
  def change
    create_table :organization_opening_hours, id: :uuid do |t|
      t.belongs_to :organization, null: false, foreign_key: { cascade: true }, type: :uuid
      t.integer :day, null: false
      t.time :open, null: false
      t.time :close, null: false

      t.timestamps
    end

    add_index :organization_opening_hours, %i[organization_id day], unique: true
  end
end
