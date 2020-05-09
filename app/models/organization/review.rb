# frozen_string_literal: true

class Organization
  class Review < ApplicationRecord
    include Recaptcha::Adapters::ControllerMethods
    attr_accessor :recaptcha_token, :remote_ip

    belongs_to :organization
    validates :rating,
              presence: true,
              numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 5, only_integer: true }
    validates :response_time, presence: true, numericality: { greater_than_or_equal_to: 0, only_integer: true }
    validates :recaptcha_token, :remote_ip, presence: true, on: :create
    validate :validate_recaptcha, on: :create
    after_commit :queue_organization_update_review_statistics_worker, on: :update, if: :saved_change_to_published?
    scope :published, -> { where(published: true) }
    scope :unpublished, -> { where(published: false) }

    protected

    def validate_recaptcha
      return unless recaptcha_token && remote_ip && verify_recaptcha(model: self, response: recaptcha_token)

      self.recaptcha_score = recaptcha_reply['score']
    end

    def request
      OpenStruct.new(remote_ip: remote_ip)
    end

    def queue_organization_update_review_statistics_worker
      Organization::UpdateReviewStatisticsWorker.perform_async(organization_id)
    end
  end
end
