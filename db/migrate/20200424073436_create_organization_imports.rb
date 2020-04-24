# frozen_string_literal: true

class CreateOrganizationImports < ActiveRecord::Migration[6.0]
  def change
    create_table :organization_imports, id: :uuid do |t|
      t.belongs_to :user, null: false, foreign_key: { cascade: true }, type: :uuid, index: true
      t.text :content, null: false
      t.text :error_message
      t.timestamp :imported_at

      t.timestamps
    end
  end
end
