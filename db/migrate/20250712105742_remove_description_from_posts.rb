class RemoveDescriptionFromPosts < ActiveRecord::Migration[7.1]
  def change
    remove_column :posts, :description, :string
  end
end
