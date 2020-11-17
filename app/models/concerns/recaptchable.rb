# frozen_string_literal: true

module Recaptchable
  extend ActiveSupport::Concern

  included do
    include Recaptcha::Adapters::ControllerMethods
    attr_accessor :recaptcha_token, :remote_ip

    validates :recaptcha_token, :remote_ip, presence: true, on: :create
    validate :validate_recaptcha, on: :create

    protected

    def validate_recaptcha
      return unless recaptcha_token && remote_ip && verify_recaptcha(model: self, response: recaptcha_token)

      self.recaptcha_score = recaptcha_reply['score']
    end

    def request
      OpenStruct.new(remote_ip: remote_ip)
    end
  end
end
