# frozen_string_literal: true

class CreateContacts < ActiveRecord::Migration[6.0]
  def change
    create_table :contacts, id: :uuid do |t|
      t.string :email, null: false
      t.string :subject, null: false
      t.text :message, null: false
      t.float :recaptcha_score, null: false, default: 0

      t.timestamps
    end
  end
end
