# frozen_string_literal: true

class VercelObserver < ActiveRecord::Observer
  observe Organization,
          Organization::OpeningHour,
          Organization::SubdivisionConnection,
          Country,
          Country::Subdivision,
          Influencer

  def after_save(_record)
    HTTParty.post(ENV['VERCEL_WEBHOOK_URL']) unless Rails.env.development?
  end

  def after_destroy(_record)
    HTTParty.post(ENV['VERCEL_WEBHOOK_URL']) unless Rails.env.development?
  end
end
