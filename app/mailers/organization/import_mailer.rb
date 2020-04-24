# frozen_string_literal: true

class Organization
  class ImportMailer < ApplicationMailer
    def notify(import_id)
      @import = Organization::Import.find_by(id: import_id)

      return unless @import

      mail(to: @import.user.email, subject: 'Your organization CSV import is complete')
    end
  end
end
