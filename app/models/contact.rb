# frozen_string_literal: true

class Contact < ApplicationRecord
  include Recaptchable
  validates :subject, :message, presence: true
  validates :email, presence: true, format: {
    with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i,
    message: 'must be a valid email address'
  }
  after_commit :queue_mailer, on: :create

  protected

  def queue_mailer
    ContactMailer.notify(id).deliver_later
  end
end
