class AddDateToEventInstances < ActiveRecord::Migration[7.1]
  def change
    add_column :event_instances, :date, :date
  end
end
