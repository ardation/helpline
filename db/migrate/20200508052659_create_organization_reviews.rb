# frozen_string_literal: true

class CreateOrganizationReviews < ActiveRecord::Migration[6.0]
  def change
    create_table :organization_reviews, id: :uuid do |t|
      t.belongs_to :organization, null: false, foreign_key: { cascade: true }, type: :uuid, index: true
      t.integer :rating, null: false, default: 0, index: true
      t.text :content, null: true
      t.integer :response_time, null: false, default: 0
      t.float :recaptcha_score, null: false, default: 0
      t.boolean :published, null: false, default: false, index: true

      t.timestamps
    end
  end
end
