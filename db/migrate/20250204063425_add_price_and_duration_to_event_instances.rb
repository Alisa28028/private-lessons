class AddPriceAndDurationToEventInstances < ActiveRecord::Migration[7.1]
  def change
    add_column :event_instances, :price, :decimal
    add_column :event_instances, :duration, :integer
  end
end
