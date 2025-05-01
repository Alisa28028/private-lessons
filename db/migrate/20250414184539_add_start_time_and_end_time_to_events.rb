class AddStartTimeAndEndTimeToEvents < ActiveRecord::Migration[7.1]
  def change
    add_column :events, :start_time, :time unless column_exists?(:events, :start_time)
    add_column :events, :end_time, :time unless column_exists?(:events, :end_time)
  end
end
