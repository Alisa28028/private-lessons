class CreateEventInstances < ActiveRecord::Migration[7.1]
  def change
    create_table :event_instances do |t|
      t.references :event, null: false, foreign_key: true
      t.datetime :start_date
      t.datetime :end_date
      t.time :start_time
      t.time :end_time
      t.date :date

      t.timestamps
    end
  end
end
