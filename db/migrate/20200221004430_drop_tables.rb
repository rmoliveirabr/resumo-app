class DropTables < ActiveRecord::Migration[6.0]
  def change
    drop_table(:categories)
    drop_table(:category_types)
    drop_table(:categories_posts)
  end
end
