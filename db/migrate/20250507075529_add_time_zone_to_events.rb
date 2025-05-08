class AddTimeZoneToEvents < ActiveRecord::Migration[7.1]
  def change
    add_column :events, :time_zone, :string
  end
end
