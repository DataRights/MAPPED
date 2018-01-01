class CreateEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :events do |t|
      t.references :workflow_state, foreign_key: true
      t.string :title

      t.timestamps
    end
  end
end
