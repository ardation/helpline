# frozen_string_literal: true

class Contact < ApplicationRecord
  include Recaptchable
  validates :subject, :message, presence: true
  validates :email, presence: :true, format: {
    with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i,
    message: "must be a valid email address"
  }
end
