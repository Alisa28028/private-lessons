class CreateLocationsUsersJoinTable < ActiveRecord::Migration[7.1]
  def change
    create_table :locations_users, id: false do |t|
      t.references :user, null: false, foreign_key: true
      t.references :location, null: false, foreign_key: true
    end
  end
end
