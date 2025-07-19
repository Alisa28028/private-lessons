Rails.application.config.after_initialize do
  sanitizer_class = Rails::Html::SafeListSanitizer

  sanitizer_class.class_eval do
    alias_method :original_allowed_tags, :allowed_tags
    alias_method :original_allowed_attributes, :allowed_attributes

    def allowed_tags(*args, **kwargs)
      original_allowed_tags(*args, **kwargs) + ['u']
    end

    def allowed_attributes(*args, **kwargs)
      original_allowed_attributes(*args, **kwargs) + ['style']
    end
  end
end
