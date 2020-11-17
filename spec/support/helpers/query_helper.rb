# frozen_string_literal: true

module QueryHelper
  extend ActiveSupport::Concern

  class Response
    attr_reader :response

    class << self
      attr_accessor :instance

      delegate :response_data, :response_errors, to: :instance, allow_nil: true
    end

    def initialize(response)
      @response = response
      self.class.instance = self
    end

    def response_data
      response['data']
    end

    def response_errors
      response['errors']
    end
  end

  def resolve(query, variables: {}, context: {})
    response = HelplineSchema.execute(query, variables: variables, context: context)
    QueryHelper::Response.new(response)
  end

  def response_data
    QueryHelper::Response.response_data
  end

  def response_errors
    QueryHelper::Response.response_errors
  end

  def response
    QueryHelper::Response.instance.response
  end

  def invalid_response_data
    return unless response_errors

    response_errors.first.try(:[], 'message')
  end

  included do
    after do
      QueryHelper::Response.instance = nil
    end
  end
end
