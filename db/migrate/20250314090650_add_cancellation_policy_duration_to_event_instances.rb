class AddCancellationPolicyDurationToEventInstances < ActiveRecord::Migration[7.1]
  def change
    add_column :event_instances, :cancellation_policy_duration, :integer
  end
end
