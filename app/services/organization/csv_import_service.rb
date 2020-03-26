# frozen_string_literal: true

require 'csv'

class Organization
  class CsvImportService
    attr_reader :file

    def self.import(file)
      new(file).import
    end

    def initialize(file)
      @file = file
    end

    def import
      CSV.parse(contents, headers: true) do |row|
        attributes = attributes_from_row(row)
        organization = Organization.find_or_initialize_by(
          name: attributes['name'], country_code: attributes['country_code']
        )
        organization.attributes = attributes
        organization.save
      end
    end

    protected

    def contents
      CsvEncodingService.normalized_utf8(file.read)
    end

    def attributes_from_row(row)
      ActionController::Parameters.new(organization: row.to_hash).require(:organization).permit(
        :name, :country_code, :region, :phone_word, :phone_number, :sms_word, :sms_number, :chat_url, :url,
        :notes, :timezone, :human_support_type_list, :issue_list, :category_list
      )
    end
  end
end
