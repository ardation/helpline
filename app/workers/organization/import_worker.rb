# frozen_string_literal: true

class Organization
  class ImportWorker
    include Sidekiq::Worker

    def perform(import_id)
      Organization::Import.find_by(id: import_id)&.import
    end
  end
end
