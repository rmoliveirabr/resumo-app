class AddYearToPost < ActiveRecord::Migration[6.0]
  def change
    add_reference :posts, :year, null: true, foreign_key: true
  end
end
