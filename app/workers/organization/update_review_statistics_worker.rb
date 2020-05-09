# frozen_string_literal: true

class Organization
  class UpdateReviewStatisticsWorker
    include Sidekiq::Worker

    def perform(organization_id)
      Organization.find_by(id: organization_id)&.update_review_statistics
    end
  end
end
