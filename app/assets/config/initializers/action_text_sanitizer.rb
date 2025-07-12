Rails.application.config.after_initialize do
  # Extend sanitizer to allow <u> tags with style attribute
  Rails::Html::WhiteListSanitizer.allowed_tags.add('u')
  Rails::Html::WhiteListSanitizer.allowed_attributes.add('style')
end
