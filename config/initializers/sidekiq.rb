# frozen_string_literal: true

Sidekiq.configure_client do |config|
  config.redis = { url: ENV.fetch(Rails.env.production? ? 'HEROKU_REDIS_CRIMSON_URL' : 'REDIS_URL') }
end

Sidekiq.configure_server do |config|
  config.redis = { url: ENV.fetch(Rails.env.production? ? 'HEROKU_REDIS_CRIMSON_URL' : 'REDIS_URL') }

  config.error_handlers << proc { |exception, context_hash| Rollbar.error(exception, context_hash) }
end

Sidekiq.default_worker_options = {
  backtrace: false,
  unique_expiration: 24.hours
}
