class AddDefaultCapacityToEvent < ActiveRecord::Migration[7.1]
  def change
    add_column :events, :default_capacity, :integer, default: 10, null: false
    add_column :event_instances, :capacity, :integer
  end
end
