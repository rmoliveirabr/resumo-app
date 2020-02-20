class RemoveDecriptionFromPosts < ActiveRecord::Migration[6.0]
  def change

    remove_column :posts, :description, :text
  end
end
