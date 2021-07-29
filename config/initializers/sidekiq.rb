require 'sidekiq'
require 'sidekiq/web'
require 'sidekiq-scheduler/web'

Sidekiq.configure_server do |config|
  config.redis = { url: ENV['REDIS_URL'], verify_mode: OpenSSL::SSL::VERIFY_NONE }
end