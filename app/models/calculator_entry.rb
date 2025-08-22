class CalculatorEntry < ApplicationRecord
  belongs_to :user, optional: true # optional if you might have entries not linked to a user

  # Validation for attendees (max 50)
  validates :lessons, :attendees, :price, presence: true
  validates :attendees, numericality: { less_than_or_equal_to: 50 }

  # Callback to calculate commission and status before saving
  before_save :calculate_commission_and_status

  private

  def calculate_commission_and_status
    total_revenue = lessons * attendees * price
    self.commission = (total_revenue * 0.15).to_i

    self.status = if commission > 40_000
                    "eligible"
                  elsif commission >= 30_000 && commission <= 40_000
                    "negotiable"
                  else
                    "not eligible"
                  end
  end
end
