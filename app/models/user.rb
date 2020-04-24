# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable

  has_many :organization_imports, class_name: 'Organization::Import', dependent: :destroy
end
