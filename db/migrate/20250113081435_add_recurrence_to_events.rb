class AddRecurrenceToEvents < ActiveRecord::Migration[7.1]
  def change
    add_column :events, :recurrence_type, :string
    add_column :events, :recurrence_details, :text
  end
end
