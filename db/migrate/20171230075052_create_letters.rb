class CreateLetters < ActiveRecord::Migration[5.1]
  def change
    create_table :letters do |t|
      t.integer :letter_type
      t.string :suggested_text
      t.string :final_text
      t.string :remarks
      t.references :workflow_transition, foreign_key: true

      t.timestamps
    end
  end
end
