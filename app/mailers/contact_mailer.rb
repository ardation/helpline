# frozen_string_literal: true

class ContactMailer < ApplicationMailer
  def notify(contact_id)
    @contact = Contact.find_by(id: contact_id)

    return unless @contact

    mail(to: ENV.fetch('CONTACT_EMAIL'), reply_to: @contact.email, subject: 'New contact submission on Find A Helpline')
  end
end
