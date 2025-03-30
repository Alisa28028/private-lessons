class AddLocationIdToEventInstances < ActiveRecord::Migration[7.1]
  def change
    add_column :event_instances, :location_id, :integer
  end
end
