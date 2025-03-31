class AddNotNullConstraintToUserIdInLocations < ActiveRecord::Migration[7.1]
  def change
    change_column_null :locations, :user_id, false
  end
end
