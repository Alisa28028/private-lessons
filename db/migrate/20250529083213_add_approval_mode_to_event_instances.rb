class AddApprovalModeToEventInstances < ActiveRecord::Migration[7.1]
  def change
    add_column :event_instances, :approval_mode, :string
  end
end
