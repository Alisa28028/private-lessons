Sidekiq.configure_server do |config|
  config.redis = { url: 'redis://localhost:6379/0' }


  # Debugging the CLOUDINARY_URL environment variable
  uri = URI.parse(ENV['CLOUDINARY_URL'])

  Rails.logger.debug("Cloudinary URI: #{uri.inspect}")
  Rails.logger.debug("Cloud Name: #{uri.host}")
  Rails.logger.debug("API Key: #{uri.user}")
  Rails.logger.debug("API Secret: #{uri.password}")
end
