class AddDashboardPreferenceToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :dashboard_preference, :string
  end
end
