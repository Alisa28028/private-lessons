class ChangeStartTimeAndEndTimeToDateTimeInEventInstances < ActiveRecord::Migration[7.1]
  def up
    # Convert start_time to datetime
    change_column :event_instances, :start_time, :datetime, using: "TO_TIMESTAMP(CONCAT('2000-01-01 ', start_time), 'YYYY-MM-DD HH24:MI:SS')"

    # Convert end_time to datetime
    change_column :event_instances, :end_time, :datetime, using: "TO_TIMESTAMP(CONCAT('2000-01-01 ', end_time), 'YYYY-MM-DD HH24:MI:SS')"
  end

  def down
    # Convert start_time back to time
    change_column :event_instances, :start_time, :time, using: "start_time::time"

    # Convert end_time back to time
    change_column :event_instances, :end_time, :time, using: "end_time::time"
  end
end
