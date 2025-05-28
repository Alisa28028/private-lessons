class AddApprovalModeToEvents < ActiveRecord::Migration[7.1]
  def change
    add_column :events, :approval_mode, :string
  end
end
