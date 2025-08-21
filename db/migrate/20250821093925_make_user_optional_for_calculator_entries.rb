class MakeUserOptionalForCalculatorEntries < ActiveRecord::Migration[7.1]
  def change
    change_column_null :calculator_entries, :user_id, true
  end
end
