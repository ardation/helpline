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
      organization = Organization.find_or_initialize_by(
        name: attributes['name'], country_code: attributes['country_code']
      )
      organization.attributes = attributes

      organization
    end

    def contents
      CsvEncodingService.normalized_utf8(file.read)
    end

    def attributes_from_row(row)
      ActionController::Parameters.new(organization: row.to_hash).require(:organization).permit(
        :name, :country_code, :region, :phone_word, :phone_number, :sms_word, :sms_number, :chat_url, :url,
        :notes, :timezone, :human_support_type_list, :issue_list, :category_list
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
