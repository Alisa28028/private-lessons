class AddDayOfWeekToEvents < ActiveRecord::Migration[7.1]
  def change
    add_column :events, :day_of_week, :string
  end
end
