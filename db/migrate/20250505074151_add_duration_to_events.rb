class AddDurationToEvents < ActiveRecord::Migration[7.1]
  def change
    add_column :events, :duration, :integer
  end
end
