# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CsvEncodingService, type: :service do
  describe '.normalized_utf8' do
    [
      ['', ''],
      [1, '1'],
      [nil, ''],
      %w[USA USA],
      ["a\r\nb", "a\nb"],
      %w[a\nb a\nb],
      %w[Agapé Agapé],
      %w[Agapé Agapé],
      %w[Agapé Agapé], # ISO-8859-1
      ["T\xE9st", 'Tést'], # ISO-8859-2
      ["\xEF\xBB\xBFTést".dup.force_encoding('UTF-8'), 'Tést'] # byte-order-mark
    ].each do |str, normalized|
      it 'normalizes to uft8 without byte-order-mark, and with universal line endings' do
        expect(described_class.normalized_utf8(str)).to eq(normalized)
      end
    end
  end
end
