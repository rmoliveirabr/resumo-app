class CreateTopics < ActiveRecord::Migration[6.0]
  def change
    create_table :topics do |t|
      t.string :topic_text

      t.timestamps
    end
    add_index :topics, :topic_text, unique: true
  end
end
