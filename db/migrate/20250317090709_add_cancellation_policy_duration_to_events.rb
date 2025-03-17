class AddCancellationPolicyDurationToEvents < ActiveRecord::Migration[7.1]
  def change
    add_column :events, :cancellation_policy_duration, :integer
  end
end
