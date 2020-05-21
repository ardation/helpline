# frozen_string_literal: true

require 'rspec/retry'

return unless ENV['CI']

RSpec.configure do |config|
  config.verbose_retry = true
  config.display_try_failure_messages = true

  config.around do |ex|
    ex.run_with_retry retry: 3
  end
end
