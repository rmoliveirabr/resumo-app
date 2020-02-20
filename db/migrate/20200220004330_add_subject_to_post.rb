class AddSubjectToPost < ActiveRecord::Migration[6.0]
  def change
    add_reference :posts, :subject, null: true, foreign_key: true
  end
end
