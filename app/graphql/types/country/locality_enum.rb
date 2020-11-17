# frozen_string_literal: true

module Types
  module Country
    class LocalityEnum < Types::BaseEnum
      ::Country.localities.each do |key, _value|
        value key.upcase, value: key
      end
    end
  end
end
