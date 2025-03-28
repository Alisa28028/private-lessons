class AddUserToLocations < ActiveRecord::Migration[7.1]
  def change
    add_reference :locations, :user, foreign_key: true, null: true
  end
end
