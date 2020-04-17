# frozen_string_literal: true

class AddRemoteIdToOrganizations < ActiveRecord::Migration[6.0]
  def change
    add_column :organizations, :remote_id, :string
    add_index :organizations, :remote_id, unique: true
  end
end
