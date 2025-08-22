class AddGuestNameAndSessionTokenToCalculatorEntries < ActiveRecord::Migration[7.1]
  def change
    add_column :calculator_entries, :guest_name, :string
    add_column :calculator_entries, :session_token, :string
  end
end
