class ChangeLocationIdToNullableInEvents < ActiveRecord::Migration[7.1]
  def change
    change_column_null :events, :location_id, true
  end
end
