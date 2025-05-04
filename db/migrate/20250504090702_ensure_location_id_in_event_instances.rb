class EnsureLocationIdInEventInstances < ActiveRecord::Migration[7.1]
  def change
    unless column_exists?(:event_instances, :location_id)
      add_reference :event_instances, :location, foreign_key: true
    end

    # Ensure it's nullable (in case it was previously NOT NULL)
    if column_exists?(:event_instances, :location_id)
      change_column_null :event_instances, :location_id, true
    end
  end
end
