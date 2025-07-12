class AddEventInstanceIdToPosts < ActiveRecord::Migration[7.1]
  def change
    add_column :posts, :event_instance_id, :integer
  end
end
