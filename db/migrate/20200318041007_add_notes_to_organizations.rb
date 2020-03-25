# frozen_string_literal: true

class AddNotesToOrganizations < ActiveRecord::Migration[6.0]
  def change
    add_column :organizations, :notes, :text
  end
end
