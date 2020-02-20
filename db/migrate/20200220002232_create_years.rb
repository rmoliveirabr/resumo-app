class CreateYears < ActiveRecord::Migration[6.0]
  def change
    create_table :years do |t|
      t.string :year_text

      t.timestamps
    end
    add_index :years, :year_text, unique: true
  end
end
