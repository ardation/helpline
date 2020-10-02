# frozen_string_literal: true

class CreateInfluencers < ActiveRecord::Migration[6.0]
  def change
    create_table :influencers, id: :uuid do |t|
      t.string :name, null: false
      t.string :slug, null: false
      t.text :message, null: false

      t.timestamps
    end

    add_index :influencers, :slug, unique: true
  end
end
