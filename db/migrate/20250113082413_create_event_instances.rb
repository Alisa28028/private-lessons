class CreateEventInstances < ActiveRecord::Migration[7.1]
  def change
    create_table :event_instances do |t|
      t.references :event, null: false, foreign_key: true
      t.datetime :start_time
      t.datetime :end_time

      t.timestamps
    end
  end
end
