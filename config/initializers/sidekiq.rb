Sidekiq.configure_server do |config|
  redis_url = ENV['REDIS_URL'] # Get the Redis URL from environment variables
  config.redis = { url: redis_url, ssl_params: { verify_mode: OpenSSL::SSL::VERIFY_NONE } }

  # Debugging the CLOUDINARY_URL environment variable
  uri = URI.parse(ENV['CLOUDINARY_URL'])

  Rails.logger.debug("Cloudinary URI: #{uri.inspect}")
  Rails.logger.debug("Cloud Name: #{uri.host}")
  Rails.logger.debug("API Key: #{uri.user}")
  Rails.logger.debug("API Secret: #{uri.password}")
end

Sidekiq.configure_client do |config|
  config.redis = {
    url: ENV['REDIS_URL'],
    ssl_params: { verify_mode: OpenSSL::SSL::VERIFY_NONE }
  }
end
