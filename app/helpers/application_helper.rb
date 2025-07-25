module ApplicationHelper
  def friendly_time_zone_name(iana_tz)
    return "" unless iana_tz.present?
    city = iana_tz.split("/").last.gsub("_", " ")
    "#{city} time"
  end

  def studio_icon_url(location_name)
    case location_name&.downcase
    when /en studio/
      helpers.asset_path("studios/en_dance.png")
    when /noa studio/
      helpers.asset_path("studios/noa_dance.png")
    else
      helpers.asset_path("PL_logo.png")
    end
  end

  def formatted_content(text)
    sanitize(text, tags: %w[b i em strong u ul ol li br p], attributes: [])
  end

  def white_icon_paths
    [
      '/',                      # Homepage
      '/dashboard/student',     # Student dashboard
      '/dashboard/teacher'      # Teacher dashboard
    ]
  end


end
