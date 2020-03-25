# frozen_string_literal: true

require 'charlock_holmes'
require 'csv'

class CsvEncodingService
  BYTE_ORDER_MARKER = "\xEF\xBB\xBF"

  def self.normalized_utf8(contents)
    contents = contents.to_s
    return '' if contents == ''

    encoding_info = CharlockHolmes::EncodingDetector.detect(contents)
    return nil unless encoding_info && encoding_info[:encoding]

    encoding = encoding_info[:encoding]
    contents = CharlockHolmes::Converter.convert(contents, encoding, 'UTF-8')

    # Remove byte order mark
    contents.sub!(CsvEncodingService::BYTE_ORDER_MARKER, '')

    contents.encode(universal_newline: true)
  end
end
