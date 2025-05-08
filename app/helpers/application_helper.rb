module ApplicationHelper
  def friendly_time_zone_name(iana_tz)
    return "" unless iana_tz.present?
    city = iana_tz.split("/").last.gsub("_", " ")
    "#{city} time"
  end
end
