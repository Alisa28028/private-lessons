class ChangeStartTimeAndEndTimeToTime < ActiveRecord::Migration[7.1]
  # def change
  #   # Remove the existing datetime columns
  #   remove_column :events, :start_time, :datetime
  #   remove_column :events, :end_time, :datetime

  #   # Add new columns with time type
  #   add_column :events, :start_time, :time
  #   add_column :events, :end_time, :time
  # end
  def up
    change_column :events, :start_time, :time
    change_column :events, :end_time, :time
  end

  def down
    change_column :events, :start_time, :datetime
    change_column :events, :end_time, :datetime
  end
end
