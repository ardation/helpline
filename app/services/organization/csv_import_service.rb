# frozen_string_literal: true

require 'csv'

class Organization
  class CsvImportService
    class ValidationError < StandardError; end
    attr_reader :file

    def self.import(file)
      new(file).import
    end

    def initialize(file)
      @file = file
    end

    def import
      errors = []
      CSV.parse(contents, headers: true).each.with_index(1) do |row, index|
        organization = build_organization_from_row(row)
        update_opening_hours_from_row(row, organization)

        errors << "Row #{index}: #{organization.errors.full_messages.join(', ')}" unless organization.save
      end
      raise ValidationError, "CSV imported with some errors! \n#{errors.join("\n")}" if errors.present?
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
      subdivisions = country && subdivision_codes&.split(',')&.map do |subdivision_code|
        country.subdivisions.find_or_create_by(code: subdivision_code&.upcase)
      end
      organization = find_organization(name, country, remote_id)
      organization ||= Organization.new(name: name)
      organization.country = country if country.persisted?
      organization.subdivisions = subdivisions if subdivisions.present?
      organization
    end

    def find_organization(name, country, remote_id)
      organization = Organization.find_by(remote_id: remote_id) if remote_id.blank?
      organization || Organization.find_by(name: name, country: country.id.nil? ? nil : country)
    end

    def contents
      CsvEncodingService.normalized_utf8(file.read)
    end

    def attributes_from_row(row)
      ActionController::Parameters.new(organization: row.to_hash).require(:organization).permit(
        :name, :phone_word, :phone_number, :sms_word, :sms_number, :chat_url, :url,
        :notes, :timezone, :human_support_type_list, :topic_list, :category_list, :remote_id
      )
    end

    def update_opening_hours_from_row(row, organization)
      attributes = row.to_hash
      Organization::OpeningHour.days.each do |day, _index|
        next unless attributes["#{day}_open"] && attributes["#{day}_close"]

        organization.opening_hours.build(
          day: day,
          open: DateTime.parse(attributes["#{day}_open"]),
          close: DateTime.parse(attributes["#{day}_close"])
        )
      end
    end
  end
end
