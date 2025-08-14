class Ahoy::Visit < ApplicationRecord
  self.table_name = "ahoy_visits"

  has_many :events, class_name: "Ahoy::Event"
  belongs_to :user, optional: true

  after_create :geocode_ip_if_needed

  private

  def geocode_ip_if_needed
    return if country.present? || ip.blank?
    results = Geocoder.search(ip).first
    update(
      country: results&.country,
      region: results&.state,
      city: results&.city
    )
  rescue => e
    Rails.logger.error("Failed to geocode IP #{ip}: #{e.message}")
  end
end
