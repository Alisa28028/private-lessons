# Be sure to restart your server when you modify this file.

Rails.application.config.assets.version = "1.0"

# Add JS/CSS and other assets
Rails.application.config.assets.precompile += %w(
  bootstrap.min.js
  popper.js
  manifest.json
)

# Precompile all PNGs inside app/assets/images/icons/
Rails.application.config.assets.precompile += Dir.glob(
  Rails.root.join("app/assets/images/icons/*")
).map { |f| "icons/#{File.basename(f)}" }
