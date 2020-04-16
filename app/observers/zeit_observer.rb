# frozen_string_literal: true

class ZeitObserver < ActiveRecord::Observer
  observe Organization, Organization::OpeningHour, Organization::SubdivisionConnection, Country, Country::Subdivision

  def after_save(_record)
    HTTParty.get(ENV['ZEIT_WEBHOOK_URL']) unless Rails.env.development?
  end

  def after_destroy(_record)
    HTTParty.get(ENV['ZEIT_WEBHOOK_URL']) unless Rails.env.development?
  end
end
