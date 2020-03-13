# frozen_string_literal: true

class CreateOrganizations < ActiveRecord::Migration[6.0]
  def change
    create_table :organizations, id: :uuid do |t|
      t.string :name, null: false
      t.string :country_code, null: false, index: true
      t.string :region
      t.string :phone_word
      t.string :phone_number
      t.string :sms_word
      t.string :sms_number
      t.string :chat_url
      t.string :url
      t.string :slug

      t.timestamps
    end

    add_index :organizations, :slug, unique: true
  end
end
