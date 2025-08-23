class AddGuestNameAndEmailAndSessionTokenToCalculatorEntries < ActiveRecord::Migration[7.1]
  def change
    add_column :calculator_entries, :guest_name, :string unless column_exists?(:calculator_entries, :guest_name)
    add_column :calculator_entries, :email, :string unless column_exists?(:calculator_entries, :email)
    add_column :calculator_entries, :session_token, :string unless column_exists?(:calculator_entries, :session_token)
  end
end
