class AddSocialLinksToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :instagram, :string
    add_column :users, :x, :string
    add_column :users, :tiktok, :string
  end
end
