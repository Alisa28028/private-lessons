class AddStudioToWeeklyAvailabilities < ActiveRecord::Migration[7.1]
  def change
    add_reference :weekly_availabilities, :studio, foreign_key: true
  end
end
