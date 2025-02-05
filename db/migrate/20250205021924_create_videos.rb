class CreateVideos < ActiveRecord::Migration[7.1]
  def change
    create_table :videos do |t|
      t.references :event, null: false, foreign_key: true
      t.references :event_instance, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :url

      t.timestamps
    end
  end
end
