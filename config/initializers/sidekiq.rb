require 'sidekiq/api'

# dont forget `heroku ps:scale worker=1`

Sidekiq.configure_server do |config|
  if Rails.env.production?
    config.redis = { url: ENV["REDIS_URL"] }
  end
end

Sidekiq.configure_client do |config|
  if Rails.env.production?
    config.redis = { url: ENV["REDIS_URL"] }
  end
end