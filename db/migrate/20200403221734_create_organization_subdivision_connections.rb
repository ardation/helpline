# frozen_string_literal: true

class CreateOrganizationSubdivisionConnections < ActiveRecord::Migration[6.0]
  def change
    create_table :organization_subdivision_connections, id: :uuid do |t|
      t.belongs_to :organization, null: false, foreign_key: { cascade: true }, type: :uuid, index: true
      t.belongs_to :subdivision,
                   null: false,
                   foreign_key: { cascade: true, to_table: :country_subdivisions },
                   type: :uuid,
                   index: true

      t.timestamps
    end

    add_index :organization_subdivision_connections,
              %i[organization_id subdivision_id],
              unique: true,
              name: 'organization_subdivision_uniq_idx'
  end
end
