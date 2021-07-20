# frozen_string_literal: true

require 'csv'

class Organization
  class ImportService
    attr_reader :record

    def self.import(record)
      new(record).import
    end

    def initialize(record)
      @record = record
    end

    def import
      errors = []
      CSV.parse(record.content, headers: true).each.with_index(1) do |row, index|
        organization = build_organization_from_row(row)
        update_opening_hours_from_row(row, organization)

        organization.save!
      rescue ActiveRecord::RecordInvalid => e
        errors << "Row #{index}: #{format_error_message(e.message)}"
      end
      return "CSV imported with some errors! \n#{errors.join("\n")}" if errors.present?
    end

    protected

    def build_organization_from_row(row)
      attributes = attributes_from_row(row)
      organization = build_organization(
        attributes['name'], row['country_code'], row['subdivision_codes'], attributes['remote_id']
      )
      organization.attributes = attributes

      organization
    end

    def build_organization(name, country_code, subdivision_codes, remote_id)
      country = Country.find_or_create_by(code: country_code&.upcase)
      subdivisions = find_subdivisions(country, subdivision_codes) if country.persisted?
      organization = find_organization(name, country, remote_id)
      organization ||= Organization.new(name: name)
      organization.country = country if country.persisted?
      organization.subdivisions = subdivisions if subdivisions.present?
      organization
    end

    def find_subdivisions(country, subdivision_codes)
      country && subdivision_codes&.split(',')&.map do |subdivision_code|
        country.subdivisions.find_or_create_by!(code: subdivision_code&.upcase)
      end
    end

    def find_organization(name, country, remote_id)
      organization = Organization.find_by(remote_id: remote_id) if remote_id.present?
      organization || Organization.find_by(name: name, country: country.id.nil? ? nil : country)
    end

    def attributes_from_row(row)
      ActionController::Parameters.new(organization: row.to_hash).require(:organization).permit(
        :name, :phone_word, :phone_number, :sms_word, :sms_number, :chat_url, :url,
        :notes, :timezone, :human_support_type_list, :topic_list, :category_list, :remote_id
      )
    end

    def update_opening_hours_from_row(row, organization)
      attributes = row.to_hash

      if attributes['always_open']&.downcase == 'yes'
        organization.always_open = true
        return
      end

      Organization::OpeningHour.days.each_key do |day|
        build_opening_hour(organization, attributes, day)
      end
    end

    def build_opening_hour(organization, attributes, day)
      return unless attributes["#{day}_open"].present? && attributes["#{day}_close"].present?

      organization.opening_hours.build(
        day: day,
        open: safe_date_time_parse(attributes["#{day}_open"]),
        close: safe_date_time_parse(attributes["#{day}_close"])
      )
    end

    def safe_date_time_parse(string)
      DateTime.parse(string)
    rescue Date::Error
      nil
    end

    def format_error_message(message)
      message
        .remove('Validation failed: ')
        .gsub('Code is not included in the list', 'Subdivision code is invalid')
    end
  end
end
