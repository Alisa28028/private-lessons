class AddCustomDatesToEvents < ActiveRecord::Migration[7.1]
  def change
    add_column :events, :custom_dates, :text
  end
end
