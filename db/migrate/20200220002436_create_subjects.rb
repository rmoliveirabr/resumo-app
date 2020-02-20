class CreateSubjects < ActiveRecord::Migration[6.0]
  def change
    create_table :subjects do |t|
      t.string :subject_text

      t.timestamps
    end
    add_index :subjects, :subject_text, unique: true
  end
end
