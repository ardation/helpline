# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'noreply@findahelpline.com'
  layout 'mailer'
end
