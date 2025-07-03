module ApplicationHelper
  def friendly_time_zone_name(iana_tz)
    return "" unless iana_tz.present?
    city = iana_tz.split("/").last.gsub("_", " ")
    "#{city} time"
  end

  def studio_icon_url(location_name)
    case location_name&.downcase
    when /en studio/
      asset_path("studios/en_studio.png")
    when /noa studio/
      asset_path("studios/noa_dance.png")
    else
      asset_path("PL_logo.png")
    end
  end

end
