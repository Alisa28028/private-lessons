class AddRecurrenceTypeToEvents < ActiveRecord::Migration[7.1]
  def change
    add_column :events, :recurrence_type, :string
  end
end
