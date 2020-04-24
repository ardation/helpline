# frozen_string_literal: true

class Organization
  class Import < ApplicationRecord
    include ActionView::Helpers::TextHelper

    belongs_to :user
    validates :content, presence: true
    after_commit :queue_import, on: :create

    def content=(content)
      super CsvEncodingService.normalized_utf8(content)
    end

    def import
      with_lock do
        return unless imported_at.nil?

        errors = Organization::ImportService.import(self)
        self.error_message = simple_format(errors) if errors
        self.imported_at = Time.zone.now
        save!
      end

      Organization::ImportMailer.notify(id).deliver_later
    end

    protected

    def queue_import
      Organization::ImportWorker.perform_async(id)
    end
  end
end
