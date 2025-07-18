Rails.application.config.to_prepare do
  sanitizer = ActionText::ContentHelper.sanitizer

  class << sanitizer
    def allowed_tags
      super + Set.new(['u'])
    end

    def allowed_attributes
      super + Set.new(['style'])
    end
  end
end
