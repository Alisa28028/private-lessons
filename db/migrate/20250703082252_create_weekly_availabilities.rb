class CreateWeeklyAvailabilities < ActiveRecord::Migration[7.1]
  def change
    create_table :weekly_availabilities do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :day, null: false
      t.time :start_time, null: false
      t.time :end_time, null: false
      t.string :style, null: false
      t.string :location

      t.timestamps
    end
  end
end
