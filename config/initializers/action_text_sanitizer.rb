Rails.application.config.after_initialize do
  sanitizer_class = Rails::Html::SafeListSanitizer

  # Override allowed_tags method to include 'u'
  sanitizer_class.define_singleton_method(:allowed_tags) do
    super + Set.new(['u'])
  end

  # Override allowed_attributes method to include 'style'
  sanitizer_class.define_singleton_method(:allowed_attributes) do
    super + Set.new(['style'])
  end
end
