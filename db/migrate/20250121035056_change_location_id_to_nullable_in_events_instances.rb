class ChangeLocationIdToNullableInEventsInstances < ActiveRecord::Migration[7.1]
  def change
    change_column_null :event_instances, :location_id, true
  end
end
